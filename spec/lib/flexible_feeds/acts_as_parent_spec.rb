require 'spec_helper'

module FlexibleFeeds
  describe ActsAsParent do

    context "pseudo-has_many" do
      before :each do
        @post = FactoryGirl.create(:post)
        @comment = FactoryGirl.create(:comment)
        @child_comment = FactoryGirl.create(:comment)
        @post.parent_of(@comment)
        @comment.parent_of(@child_comment)
      end

      it "children" do
        expect(@post.children).to include @comment.event
      end

      it "descendants" do
        expect(@post.descendants).to include @comment.event, @child_comment.event
      end
    end

    context "by default accepts all child types" do
      before :each do
        @post = FactoryGirl.create(:post)
      end

      it "comment" do
        comment = FactoryGirl.create(:comment)
        @post.parent_of(comment)
        expect(@post.children).to include comment.event
      end

      it "reference" do
        reference = FactoryGirl.create(:reference)
        @post.parent_of(reference)
        expect(@post.children).to include reference.event
      end

      it "picture" do
        picture = FactoryGirl.create(:picture)
        @post.parent_of(picture)
        expect(@post.children).to include picture.event
      end
    end

    context "when given a list of permitted_children only accepts those" do
      before :each do
        @post = FactoryGirl.create(:permitting_post)
      end

      it "comment" do
        comment = FactoryGirl.create(:comment)
        @post.parent_of(comment)
        expect(@post.children).to include comment.event
      end

      it "reference" do
        reference = FactoryGirl.create(:reference)
        @post.parent_of(reference)
        expect(@post.children).to include reference.event
      end

      it "picture" do
        picture = FactoryGirl.create(:picture)
        @post.parent_of(picture)
        expect(@post.children).to_not include picture.event
      end
    end

    context "when given a list of unpermitted_children only accepts those" do
      before :each do
        @post = FactoryGirl.create(:unpermitting_post)
      end

      it "comment" do
        comment = FactoryGirl.create(:comment)
        @post.parent_of(comment)
        expect(@post.children).to include comment.event
      end

      it "reference" do
        reference = FactoryGirl.create(:reference)
        @post.parent_of(reference)
        expect(@post.children).to_not include reference.event
      end

      it "picture" do
        picture = FactoryGirl.create(:picture)
        @post.parent_of(picture)
        expect(@post.children).to include picture.event
      end
    end

  end
end
