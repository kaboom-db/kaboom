require "rails_helper"

RSpec.describe "reviews/review", type: :view do
  let(:review) { FactoryBot.create(:review) }

  def perform
    render "reviews/review", review:, readonly:
  end

  context "when readonly is true" do
    let(:readonly) { true }

    context "when current user is the same as the review user" do
      before do
        allow(view).to receive(:current_user).and_return(review.user)
      end

      it "renders a link to edit and delete the review" do
        perform
        assert_select "a[href='#{edit_review_path(review)}']"
        assert_select "form[action='#{review_path(review)}']" do
          assert_select "input[type='hidden'][name='_method'][value='delete']"
        end
      end
    end

    context "when current user is not the same as the review user" do
      before do
        allow(view).to receive(:current_user).and_return(FactoryBot.create(:user))
      end

      it "does not render a link to edit and delete the review" do
        perform
        assert_select "a[href='#{edit_review_path(review)}']", count: 0
        assert_select "form[action='#{review_path(review)}']" do
          assert_select "input[type='hidden'][name='_method'][value='delete']", count: 0
        end
      end
    end

    it "renders the form in a readonly state" do
      perform
      assert_select "form[action='#{review_path(review)}']" do
        assert_select "input.bg-transparent.border-transparent[name='review[title]'][readonly]"
        assert_select "textarea.bg-transparent.border-transparent[name='review[content]'][readonly]"
      end
    end
  end

  context "when readonly is false" do
    let(:readonly) { false }

    context "when current user is the same as the review user" do
      before do
        allow(view).to receive(:current_user).and_return(review.user)
      end

      it "renders a link to save and cancel" do
        perform
        assert_select "input[type='submit'][value='Save']"
        assert_select "a[href='#{review_path(review)}']", text: "Cancel"
      end

      context "when the review is not persisted" do
        let(:review) { FactoryBot.build(:review) }

        it "does not render the cancel link" do
          perform
          assert_select "input[type='submit'][value='Save']"
          assert_select "a", text: "Cancel", count: 0
        end
      end
    end

    context "when current user is not the same as the review user" do
      before do
        allow(view).to receive(:current_user).and_return(FactoryBot.create(:user))
      end

      it "does not render a link to save or cancel" do
        perform
        assert_select "input[type='submit'][value='Save']", count: 0
        assert_select "a[href='#{review_path(review)}']", text: "Cancel", count: 0
      end
    end

    it "renders the form in an editable state" do
      perform
      assert_select "form[action='#{review_path(review)}']" do
        assert_select "input.bg-white.border-black[name='review[title]']:not([readonly])"
        assert_select "textarea.bg-white.border-black[name='review[content]']:not([readonly])"
      end
    end
  end

  context "when reviewable is a comic" do
    let(:review) { FactoryBot.create(:review, :for_comic) }
    let(:readonly) { true }

    it "renders a link to the comic" do
      perform
      assert_select "a[href='#{comic_path(review.reviewable)}']", text: "View"
    end
  end

  context "when reviewable is an issue" do
    let(:review) { FactoryBot.create(:review, :for_issue) }
    let(:readonly) { false }

    it "renders a link to the issue" do
      perform
      assert_select "a[href='#{comic_issue_path(review.reviewable, comic_id: review.reviewable.comic)}']", text: "View"
    end
  end
end
