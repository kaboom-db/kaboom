RSpec.shared_examples "a favouritable resource" do |resource_type|
  describe "POST /wishlist" do
    let(:comic) { FactoryBot.create(:comic, name: "Test Comic") }
    let(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      @resource_path = (resource_type == :comic) ? method(:comic_path) : method(:comic_issue_path)
      @favourite_resource_path = (resource_type == :comic) ? method(:favourite_comic_path) : method(:favourite_comic_issue_path)
      allow_any_instance_of(ActionDispatch::Request).to receive(:xhr?).and_return(xhr)
    end

    context "when the user is not logged in" do
      let(:xhr) { false }

      before do
        if resource_type == :comic
          @resource_id = comic
          @extra_args = {}
        else
          @resource_id = "1"
          @extra_args = {comic_id: comic.id}
        end
      end

      it "redirects to the sign in page" do
        post @favourite_resource_path.call(@resource_id, **@extra_args)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      let(:xhr) { false }

      before do
        sign_in user
      end

      context "when favouriting is unsuccessful" do
        before do
          if resource_type == :comic
            FactoryBot.create(:favourite_item, favouritable: comic, user:)

            @resource_id = comic
            @extra_args = {}
          else
            @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
            FactoryBot.create(:favourite_item, favouritable: @issue, user:)

            @resource_id = @issue
            @extra_args = {comic_id: comic.id}
          end

          post @favourite_resource_path.call(@resource_id, **@extra_args)
        end

        it "redirects to the #{resource_type} page" do
          expect(response).to redirect_to @resource_path.call(@resource_id, **@extra_args)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "Could not favourite this #{resource_type}."
        end
      end

      context "when favouriting is successful" do
        before do
          if resource_type == :comic
            @resource_id = comic
            @extra_args = {}
          else
            @issue = FactoryBot.create(:issue, comic:, issue_number: 1)

            @resource_id = @issue
            @extra_args = {comic_id: comic.id}
          end
          post @favourite_resource_path.call(@resource_id, **@extra_args)
        end

        it "redirects to the #{resource_type} page" do
          expect(response).to redirect_to @resource_path.call(@resource_id, **@extra_args)
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully favourited this #{resource_type}."
        end

        it "creates a favourited item" do
          favourited = user.favourite_items.last
          expect(favourited.favouritable).to eq @resource_id
          expect(favourited.user).to eq user
        end
      end

      if resource_type == :issue
        context "when issue does not exist" do
          before do
            post favourite_comic_issue_path("1", comic_id: comic.id)
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

      context "when favouriting is unsuccessful" do
        before do
          if resource_type == :comic
            FactoryBot.create(:favourite_item, favouritable: comic, user:)

            @resource_id = comic
            @extra_args = {}
          else
            @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
            FactoryBot.create(:favourite_item, favouritable: @issue, user:)

            @resource_id = @issue
            @extra_args = {comic_id: comic.id}
          end

          post @favourite_resource_path.call(@resource_id, **@extra_args)
        end

        it "returns valid json" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq false
          expect(body["favourited"]).to eq true
          issue_id = (resource_type == :comic) ? nil : @issue.id
          expect(body["issue"]).to eq issue_id
          name = (resource_type == :comic) ? comic.name : "#{comic.name} - #{@issue.name}"
          expect(body["message"]).to eq "Could not favourite #{name}."
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

          post @favourite_resource_path.call(@resource_id, **@extra_args)
        end

        it "returns valid json" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq true
          expect(body["favourited"]).to eq true
          issue_id = (resource_type == :comic) ? nil : @issue.id
          expect(body["issue"]).to eq issue_id
          name = (resource_type == :comic) ? comic.name : "#{comic.name} - #{@issue.name}"
          expect(body["message"]).to eq "You favourited #{name}."
        end

        it "creates a favourited item" do
          favourited = user.favourite_items.last
          expect(favourited.favouritable).to eq @resource_id
          expect(favourited.user).to eq user
        end
      end
    end
  end

  describe "POST /unfavourite" do
    let(:comic) { FactoryBot.create(:comic, name: "Test Comic") }
    let(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      @resource_path = (resource_type == :comic) ? method(:comic_path) : method(:comic_issue_path)
      @unfavourite_resource_path = (resource_type == :comic) ? method(:unfavourite_comic_path) : method(:unfavourite_comic_issue_path)
      allow_any_instance_of(ActionDispatch::Request).to receive(:xhr?).and_return(xhr)
    end

    context "when the user is not logged in" do
      let(:xhr) { false }

      before do
        if resource_type == :comic
          @resource_id = comic
          @extra_args = {}
        else
          @resource_id = "1"
          @extra_args = {comic_id: comic.id}
        end
      end

      it "redirects to the sign in page" do
        post @unfavourite_resource_path.call(@resource_id, **@extra_args)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      let(:xhr) { false }

      before do
        sign_in user
      end

      context "when the #{resource_type} is not favourited" do
        before do
          if resource_type == :comic
            @resource_id = comic
            @extra_args = {}
          else
            @issue = FactoryBot.create(:issue, comic:, issue_number: 1)

            @resource_id = @issue
            @extra_args = {comic_id: comic.id}
          end

          post @unfavourite_resource_path.call(@resource_id, **@extra_args)
        end

        it "redirects to the #{resource_type} path" do
          expect(response).to redirect_to @resource_path.call(@resource_id, **@extra_args)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "You have not favourited this #{resource_type}."
        end
      end

      context "when user is authorised to unfavourite this #{resource_type}" do
        before do
          if resource_type == :comic
            FactoryBot.create(:favourite_item, favouritable: comic, user:)

            @resource_id = comic
            @extra_args = {}
          else
            @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
            FactoryBot.create(:favourite_item, favouritable: @issue, user:)

            @resource_id = @issue
            @extra_args = {comic_id: comic.id}
          end

          post @unfavourite_resource_path.call(@resource_id, **@extra_args)
        end

        it "redirects to the #{resource_type} path" do
          expect(response).to redirect_to @resource_path.call(@resource_id, **@extra_args)
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully unfavourited this #{resource_type}."
        end

        it "destroys the favourite item" do
          expect(user.favourite_items.count).to eq 0
        end
      end

      # TODO: When user is not authorised to unfavourite the issue

      if resource_type == :issue
        context "when issue does not exist" do
          before do
            post unfavourite_comic_issue_path("1", comic_id: comic.id)
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

      context "when user is authorised to unwishlist this #{resource_type}" do
        before do
          if resource_type == :comic
            FactoryBot.create(:favourite_item, favouritable: comic, user:)

            @resource_id = comic
            @extra_args = {}
          else
            @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
            FactoryBot.create(:favourite_item, favouritable: @issue, user:)

            @resource_id = @issue
            @extra_args = {comic_id: comic.id}
          end

          post @unfavourite_resource_path.call(@resource_id, **@extra_args)
        end

        it "responds with json" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq true
          expect(body["favourited"]).to eq false
          issue_id = (resource_type == :comic) ? nil : @issue.id
          expect(body["issue"]).to eq issue_id
          name = (resource_type == :comic) ? comic.name : "#{comic.name} - #{@issue.name}"
          expect(body["message"]).to eq "You unfavourited #{name}."
        end

        it "destroys the favourite item" do
          expect(user.favourite_items.count).to eq 0
        end
      end

      # TODO: When user is not authorised
    end
  end
end
