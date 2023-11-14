RSpec.shared_examples "a wishlistable resource" do |resource_type|
  describe "POST /wishlist" do
    let(:comic) { FactoryBot.create(:comic, name: "Test Comic") }
    let(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      @resource_path = (resource_type == :comic) ? method(:comic_path) : method(:comic_issue_path)
      @wishlist_resource_path = (resource_type == :comic) ? method(:wishlist_comic_path) : method(:wishlist_comic_issue_path)
      allow_any_instance_of(ActionDispatch::Request).to receive(:xhr?).and_return(xhr)
    end

    context "when the user is not logged in" do
      let(:xhr) { false }

      before do
        @resource_id = (resource_type == :comic) ? comic : "1"
        @extra_args = (resource_type == :comic) ? {} : {comic_id: comic.id}
      end

      it "redirects to the sign in page" do
        post @wishlist_resource_path.call(@resource_id, **@extra_args)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is not logged in" do
      let(:xhr) { false }

      before do
        sign_in user
      end

      context "when wishlisting is unsuccessful" do
        before do
          if resource_type == :comic
            FactoryBot.create(:wishlist_item, wishlistable: comic, user:)

            @resource_id = comic
            @extra_args = {}
          else
            @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
            FactoryBot.create(:wishlist_item, wishlistable: @issue, user:)

            @resource_id = @issue
            @extra_args = {comic_id: comic.id}
          end
          post @wishlist_resource_path.call(@resource_id, **@extra_args)
        end

        it "redirects to the #{resource_type} page" do
          expect(response).to redirect_to @resource_path.call(@resource_id, **@extra_args)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "Could not wishlist this #{resource_type}."
        end
      end

      context "when wishlisting is successful" do
        before do
          if resource_type == :comic
            @resource_id = comic
            @extra_args = {}
          else
            @issue = FactoryBot.create(:issue, comic:, issue_number: 1)

            @resource_id = @issue
            @extra_args = {comic_id: comic.id}
          end

          post @wishlist_resource_path.call(@resource_id, **@extra_args)
        end

        it "redirects to the #{resource_type} page" do
          expect(response).to redirect_to @resource_path.call(@resource_id, **@extra_args)
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully wishlisted this #{resource_type}."
        end

        it "creates a wishlisted item" do
          wishlisted = user.wishlist_items.last
          expect(wishlisted.wishlistable).to eq @resource_id
          expect(wishlisted.user).to eq user
        end
      end

      if resource_type == :issue
        context "when issue does not exist" do
          before do
            post wishlist_comic_issue_path("1", comic_id: comic.id)
          end

          it "redirects to the comic path" do
            expect(response).to redirect_to comic_path(comic)
          end

          it "sets a flash message" do
            expect(flash[:alert]).to eq "Could not find that issue."
          end
        end
      end
    end

    context "when request is an Ajax request" do
      let(:xhr) { true }

      before do
        sign_in user
      end

      context "when wishlisting is unsuccessful" do
        before do
          if resource_type == :comic
            FactoryBot.create(:wishlist_item, wishlistable: comic, user:)

            @resource_id = comic
            @extra_args = {}
          else
            @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
            FactoryBot.create(:wishlist_item, wishlistable: @issue, user:)

            @resource_id = @issue
            @extra_args = {comic_id: comic.id}
          end

          post @wishlist_resource_path.call(@resource_id, **@extra_args)
        end

        it "returns valid json" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq false
          expect(body["wishlisted"]).to eq true
          issue_id = (resource_type == :comic) ? nil : @issue.id
          expect(body["issue"]).to eq issue_id
          name = (resource_type == :comic) ? comic.name : "#{comic.name} - #{@issue.name}"
          expect(body["message"]).to eq "Could not wishlist #{name}."
        end
      end

      context "when wishlisting is successful" do
        before do
          if resource_type == :comic
            @resource_id = comic
            @extra_args = {}
          else
            @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")

            @resource_id = @issue
            @extra_args = {comic_id: comic.id}
          end

          post @wishlist_resource_path.call(@resource_id, **@extra_args)
        end

        it "returns valid json" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq true
          expect(body["wishlisted"]).to eq true
          issue_id = (resource_type == :comic) ? nil : @issue.id
          expect(body["issue"]).to eq issue_id
          name = (resource_type == :comic) ? comic.name : "#{comic.name} - #{@issue.name}"
          expect(body["message"]).to eq "You wishlisted #{name}."
        end

        it "creates a wishlisted item" do
          wishlisted = user.wishlist_items.last
          expect(wishlisted.wishlistable).to eq @resource_id
          expect(wishlisted.user).to eq user
        end
      end
    end
  end
end
