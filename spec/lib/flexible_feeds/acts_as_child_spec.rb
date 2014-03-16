require 'spec_helper'

module FlexibleFeeds
  describe ActsAsChild do

    context "pseudo-has_one" do
      before :each do
        @post = FactoryGirl.create(:post)
        @comment = FactoryGirl.create(:comment)
        @child_comment = FactoryGirl.create(:comment)
        @post.parent_of(@comment.event)
        @comment.parent_of(@child_comment.event)
      end

      it "parent" do
        expect(@child_comment.parent).to eq @comment.event
      end

      it "ancestor" do
        expect(@child_comment.ancestor).to eq @post.event
      end
    end

    it "cannot add itself to a non-parent" do
      reference = FactoryGirl.create(:reference)
      comment = FactoryGirl.create(:comment)
      comment.child_of(reference.event)
      expect(comment.parent).to be nil
    end

    context "prompts its parents to count it and its siblings" do
      before :each do
        @post = FactoryGirl.create(:post)
        @parent_comment_1 = FactoryGirl.create(:comment)
        @parent_comment_2 = FactoryGirl.create(:comment)
        @parent_comment_3 = FactoryGirl.create(:comment)
        @child_of_parent_comment_1 = FactoryGirl.create(:comment)
        @second_child_of_parent_comment_1 = FactoryGirl.create(:comment)
        @child_of_parent_comment_2 = FactoryGirl.create(:comment)
        @parent_comment_1.child_of(@post.event)
        @parent_comment_2.child_of(@post.event)
        @parent_comment_3.child_of(@post.event)
        @child_of_parent_comment_1.child_of(@parent_comment_1.event)
        @second_child_of_parent_comment_1.child_of(@parent_comment_1.event)
        @child_of_parent_comment_2.child_of(@parent_comment_2.event)
      end

      it "so that its ancestor has a tally of all descendants" do
        expect(@post.event.children_count).to eq 6
      end

      it "so that its parent has a tally of its descendants" do
        expect(@parent_comment_1.event.children_count).to eq 2
        expect(@parent_comment_2.event.children_count).to eq 1
        expect(@parent_comment_3.event.children_count).to eq 0
      end

      it "even after destroying a child" do
        @parent_comment_1.destroy
        expect(@post.event.children_count).to eq 3
      end

      it "even after destroying a deep descendant" do
        @child_of_parent_comment_1.destroy
        expect(@post.event.children_count).to eq 5
        expect(@parent_comment_1.event.children_count).to eq 1
      end
    end

    context "can add itself to any parent type with no permissions" do
      before :each do
        @post = FactoryGirl.create(:post)
      end

      it "comment" do
        comment = FactoryGirl.create(:comment)
        comment.child_of(@post.event)
        expect(comment.parent).to eq @post.event
      end

      it "reference" do
        reference = FactoryGirl.create(:reference)
        reference.child_of(@post.event)
        expect(reference.parent).to eq @post.event
      end

      it "picture" do
        picture = FactoryGirl.create(:picture)
        picture.child_of(@post.event)
        expect(picture.parent).to eq @post.event
      end
    end

    context "can add itself to a permitted_children parent if permitted" do
      before :each do
        @post = FactoryGirl.create(:permitting_post)
      end

      it "comment" do
        comment = FactoryGirl.create(:comment)
        comment.child_of(@post.event)
        expect(comment.parent).to eq @post.event
      end

      it "reference" do
        reference = FactoryGirl.create(:reference)
        reference.child_of(@post.event)
        expect(reference.parent).to eq @post.event
      end

      it "picture" do
        picture = FactoryGirl.create(:picture)
        picture.child_of(@post.event)
        expect(picture.parent).to be nil
      end
    end

    context "can add itself to an unpermitting_children parent if not denied" do
      before :each do
        @post = FactoryGirl.create(:unpermitting_post)
      end

      it "comment" do
        comment = FactoryGirl.create(:comment)
        comment.child_of(@post.event)
        expect(comment.parent).to eq @post.event
      end

      it "reference" do
        reference = FactoryGirl.create(:reference)
        reference.child_of(@post.event)
        expect(reference.parent).to be nil
      end

      it "picture" do
        picture = FactoryGirl.create(:picture)
        picture.child_of(@post.event)
        expect(picture.parent).to eq @post.event
      end
    end

  end
end
