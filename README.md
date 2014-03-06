FlexibleFeeds [![Gem Version](https://badge.fury.io/rb/flexible_feeds.png)](http://badge.fury.io/rb/flexible_feeds) [![Build Status](https://travis-ci.org/timothycommoner/flexible_feeds.png?branch=master)](https://travis-ci.org/timothycommoner/flexible_feeds) [![Code Climate](https://codeclimate.com/github/timothycommoner/flexible_feeds.png)](https://codeclimate.com/github/timothycommoner/flexible_feeds)
=====================

FlexibleFeeds allows to you to create dynamic feed systems for a Rails app. As a comparison, check out the [Public Activity](https://github.com/timothycommoner?tab=activity) we find here on GitHub. It lists a variety of events, from creating branches to pushing new versions. With FlexibleFeeds, you can get similar functionality, but with some added perks, such as voting, sorting, and nesting events. This allows FlexibleFeeds to smoothly aggregate system-generated notices with user-generated posts and comments.

Compatibility
-------------

FlexibleFeeds is a Rails Engine, which means it plays best with Rails applications. So far, it's only been tested with Rails 4.

Installation
------------

 1. Add FlexibleFeeds to your gemfile: `gem 'flexible_feeds'`
 2. Run bundler: `bundle install`
 3. Run this in your app folder: `rake flexible_feeds:install:migrations`
 4. Run your migrations: `rake db:migrate`
 5. Add `acts_as_feedable` to the models you want to have feeds
 6. Add `acts_as_eventable` to the models you want to appear in feeds
 7. Add `acts_as_moderator` to the models you want to be moderators
 8. Add `acts_as_follower` to the models you want to be followers
 
Creating Feeds
--------------

Scenario: We want our User model to have a public activity feed, similar to the one on GitHub.

First, add `acts_as_feedable` to the User model that'll contain the feed. By default, `acts_as_feedable` will create a `has_one` relationship with its feed. This feed will be created automatically for the User in an `after_create` callback. You can then access the feed with a command like `@user.feed`

If you want the User to have multiple feeds, you can do so with:

    acts_as_feedable has_many: true

Note that FlexibleFeeds will not automatically create a feed in this case. You must manually create all of them on your own, like so:

    @user.feeds.create(name: "Public Activity")
    @user.feeds.create(name: "Private Activity")

You can then look-up your feeds by name, such as `@user.feed_named("Public Activity")`.

Creating Events
---------------

Scenario: When a user leaves a group, we want an event to appear in both her feed and the group's feed.

First, create an event model. Let's call it MembershipTermination. Within MembershipTermination, include `acts_as_eventable`. The model might look something like this:

  class MembershipTermination < ActiveRecord::Base
    belongs_to :user
    belongs_to :group
    acts_as_eventable add_to_feeds: :custom_feeds, created_by: :user

    def custom_feeds
      [user.feed, group.feed]
    end
  end

Then when the user terminates her account, the event will automatically appear in both her and the group's feed:

    MembershipTermination(user: @user, group: @group)
    @user.feed.events # => returns a list of events, including the termination

`acts_as_eventable` takes two arguments. First, `add_to_feeds` accepts a pointer to a method, which should return an array of feeds you want to post the event to after_save. Secondly, `created_by` accepts an association which assigns the creator of the event to the event. This is especially helpful for comments, posts, and other user-generated events.

You can also add an event to feeds manually:

    @membership_termination.add_to_feeds(@another_group.feed, @admin.feed)

Sorting Events
--------------

Scenario: You want to sort events by their popularity.

Events have nearly a dozen scopes intended for ordering. To get a descending list of events by popularity, you simply have to call:

    @feed.events.popular

The scopes include:

    :newest # the most recently _updated_ events
    :oldest # the oldest events
    :loudest # the events with the most children (refer to Creating Nested Events)
    :quietest # the events with the fewest children
    :controversial # the events with the most conflicting votes
    :uncontroversial # the events with the most vote agreement
    :simple_popular # the events with the highest rating
    :simple_unpopular # the events with the lowest rating
    :popular # the events with the highest lower-bound rating
    :unpopular # the events with the lowest lower-bound rating

(For an excellent description of how `popular` and `unpopular` work--and why you should use them instead of `simple_popular` and `simple_unpopular`--refer to [this blog post](http://www.evanmiller.org/how-not-to-sort-by-average-rating.html) by Evan Miller.)

Displaying Events
-----------------

Scenario: You want to display the ten newest events for a user.

First, grab the events:

    @events = @user.feed.events.newest.limit(10).includes(:eventable)

Then cycle through them in your view, displaying the associated eventable:

    <%= @events.each do |event| %>
      <%= event.eventable %>
    <% end %>

Then create a partial for the eventable:

    # /views/membership_terminations/_membership_termination.html.erb
    <p>User <%= membership_termination.user.name %> left group <%= membership_termination.group.name %>.</p>

Voting On Events
----------------

Scenario: You want your users to be able to vote upon events.

Events have a `cast_vote` method which you can add to your controller. Just pass in the voter and the value of the vote. (The value can be -1 or 1.)

    @event.cast_vote({ voter: current_user, value: params[:value] })

Any model can vote, so both of these lines could work too:

    @event.cast_vote({ voter: @group, value: 1 })
    @event.cast_vote({ voter: @bot, value: -1 })

If a voter has already voted upon an event, FlexibleFeeds will check if the pre-existing vote has the same value. If it does, it will delete both the new and old vote. If they have opposite values, then it will replace the old value with the new one.

Nesting Events
--------------

Scenario: You want an event to be commentable.

First, add `acts_as_eventable` and `acts_as_parent` to the parent event. By default, it will accept any eventable model as a child. If you want to be more specific, you can pass in a list of permitted (or unpermitted) children.

    acts_as_parent # accepts every eventable model that acts_as_child
    acts_as_parent permitted_children: [Comment, Reference] # accepts only Comment and Reference children
    acts_as_parent unpermitted_children: [Post] # accepts all acts_as_child except Post

Next, add `acts_as_eventable` and `acts_as_child` to child events. After that, you can add a child to a parent like so:

    @post = Post.find(params[:id])
    @comment = Comment.create(comment_params)
    @comment.child_of(@post)

You can also do the opposite:

    @post = Post.find(params[:id])
    @comment = Comment.create(comment_params)
    @post.parent_of(@comment)

If you made your Comment model both `acts_as_parent` and `acts_as_child`, you could get threaded comments like so:

    @parent_comment = Comment.find(params[:id])
    @child_comment = Comment.create(comment_params)
    @parent_comment.parent_of(@child_comment)

You can access children in two ways. If you only want the immediate children:

    @post.children

If you want the immediate children as well as their children (and their children, and so on), call:

    @post.descendants

This is ideal for gathering all comments in a deeply nested thread in a single call to the database. Note that `descendants` only works for top-level parents. Intermediate level parents (such as a nested comment), cannot use it.

If you should need to, you can also query up the family tree for the immediate parent:

    @comment.parent

Or if you want the top-level parent, you can do so with:

    @comment.ancestor

Following
---------

Scenario: You want users to be able to follow specific feeds, which will be aggregated in their homepage.

First, place `acts_as_follower` in your User model:

    class User < ActiveRecord::Base
      acts_as_follower
    end

Then set the user to follow the desired feed:

    @user.follow(@feed)

Later, the user can unfollow the feed:

    @user.unfollow(@feed)

You can also check to see if the user is a follower:

    @user.is_following?(@feed)

And you can also get an array of the feeds the user is follow:

    @user.followed_feeds

Finally, you can an aggregated array of all the events on the followed feeds:

    @user.aggreate_follows

Issues
------

FlexibleFeeds is still very young, and both its functionality and its documentation are bound to be lacking. If you're having trouble with something, feel free to open an issue.

Contributing
------------

Feel free to send us a pull request. Public methods, callbacks, and validations should have Rspec tests to back them up.

Contributors
------------

Timothy Baron

License
-------

Released under the MIT license.