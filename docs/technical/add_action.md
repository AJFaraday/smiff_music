# Adding new actions

This file documents how to add new actions to smiff music.

## Short Version

* add message definition in config/seeds/message_formats.yml
* add action name to AVAILABLE_ACTIONS in /lib/messages/actions.rb
* write action under a named module in lib/messages/actions/
* add translation for your returned messages to /config/locales/actions/en.yml
* extend /lib/messages/actions.rb with your named module
* document your new message under /docs/help/messages/ (under the relevant category)
* add your new help section in /config/help_pages.yml
* add a test for parsing your action to /test/models/message_test.rb
* add a test for running your action to /test/models/messages_actions_test.rb
* rake db:seed
* restart server

## Longer version

### Message Definition

The message definition declares the message a user will input to access the action, which action this will refer to and which arguments will be passed to it. 

Message definitions are declared in /config/seeds/message_formats.yml

This is a typical definition 

```yaml
play_multiple:
  name: 'play_multiple'
  regex: 'play (\w+) on (?:steps|step) ([0-9]+)((, [0-9]+)*)((?: and ([0-9]+))*)'
  variables:
    - 'pattern_name'
    - 'steps'
  action: 'add_steps'
  weight: 0
```

These attributes are:

| attribute | meaning |
| --------- | ------- |
| name | An internal name held in the database, making this record easier to identify |
| regex | A regex input mask which serves 2 purposes; to identify this message and to define which parts of the message will be returned as variables |
| variables | An array: this is a list of variables which will be passed to the action. In the order they are returned from the regex. *Note:* the last variable will always be returned as an array. Even if it only has one member. |
| action | The name of the action which will be called on Messages::Actions |
| weight | A unit of precedence, which will make sure the higher-weight actions are checked before lower-weight ones. (for instance, 'do not play' is checked before 'play'). Should not be higher than 4. |

### define action

The actual method which is called is added to Messages::Actions via a module. 

Modify /lib/messages/actions.rb

Add the action name from your method definition to the array AVAILABLE_ACTIONS 

Add a line to extend with a module named for your action, eg. 

```ruby
  extend Messages::Actions::MyAction
```

add a file for your action under /lib/messages/actions/ e.g.

```
vim lib/messasges/actions/my_action.rb
```

```ruby
module Messages::Actions::AddSteps

  def my_action(args)
    ...
    return {
      respose: 'success',
      display: I18n.t('actions.my_action.success')
    }
  end

end
```

args will always be a hash, containing variables named as per the variables attribute in the message definition with values taken from the input regex mask.

This should return a hash which defines how it interacts with the terminal. It should have these attriutes

| attribute | value | meaning |
| --------- | ----- | ------- |
| response| string (success, failure or error) | A status for your method.|
| display | string | the actual message shown to a user, should be a translation to allow modifcation later |

You should define your translation in /config/locales/actions/en.yml: e.g.:

```yaml
en:
  actions:
    my_action:
      success: 'I did my action'
      failure: "Sorry, I couldn't perform my action."
```

Your action should now work, check it from within the app. 

If your response is 'success' the returned message will be green.
If your response is 'failure' the returned message will be yellow.
If your response is 'error' the returned message will be red.

### document action

If you want people to actually use your action in SMIFF you should document it in the help section.

Add a file under /docs/help/messages for your action, under another folder for an appropriate category. e.g.

```
vim docs/help/messages/drums/clear.md
```

Use github flavoured markup to format your help file, with one important difference:

*Note:* For code blocks use \<pre\> tags

Now add your method to the help index, or it will not be included in the help section of the app.

modify /config/help_pages.yml

```yaml
---
...
- title: Available Messages
  anchor: messages
  file: '/docs/help/messages.md'
  children:
    ...
    - title: Drums
      anchor: messages_drums
      file: '/docs/help/messages/drums.md'
      children:
        ...
        - title: my action
          anchor: my_action
          file: '/docs/help/messages/drums/my_action.md'
```

There are four possible attributes for a help page:

| attribute | meaning |
| --------- | ------- |
| title | The display name for this section which appears in the help index |
| anchor | the html anchor for this section, it is usually a space-free version of the title | 
| file | The file path relative to Rails.root of the markdown file containing the contents of this page |
| Children | an array of hashes with the same attributes, the content will be rendered after this page and appear in a sub list in the help index. You should add your action under the children of an appropriate category. |

