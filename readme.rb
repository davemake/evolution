# naming of objects convention
#
# for objects that are in a state of flux, changing, on standby,
# adjective then object
def examples
  active_object
  moving_object
  whatevering_object
end
# for objects that are in a state of inersia, stationary, independent,
# object then describing noun
def examples
  object_parent
  object_child
  object_whatever
end

# vehicle guidlines and policy
#
# a system of logical components that exist to get things done (business for example)
# with absolutely minimal requirements of work, and of power, from each and every organization member;
# with absolutely maximal benefit to each and every organization member;
# made possible through the pure efficiency of bsolutely equal and timely distribution of all work, power and benefit.
#
# a typical, conventional organization of thirty or more can reduce its monthly work requirement from 20 to 2 days per month per organization member;
# whilst simultaineously increasing take home pay of each and every organization member,
# to that of the hiararchy's highest paid, top ten percent---think about this for a moment:
# one-tenth the current work-load, in exchange for the maximum amount of take-home benefit your organization can possibly provide.
# also, because the organization is running at full efficiency, the odds of your organization being able to provide more, are increased at leaste.
# 

== Debugging Rails

Sometimes your application goes wrong.  Fortunately there are a lot of tools that
will help you debug it and get it back on the rails.

First area to check is the application log files.  Have "tail -f" commands running
on the server.log and development.log. Rails will automatically display debugging
and runtime information to these files. Debugging info will also be shown in the
browser on requests from 127.0.0.1.

You can also log your own messages directly into the log file from your code using
the Ruby logger class from inside your controllers. Example:

  class WeblogController < ActionController::Base
    def destroy
      @weblog = Weblog.find(params[:id])
      @weblog.destroy
      logger.info("#{Time.now} Destroyed Weblog ID ##{@weblog.id}!")
    end
  end

The result will be a message in your log file along the lines of:

  Mon Oct 08 14:22:29 +1000 2007 Destroyed Weblog ID #1

More information on how to use the logger is at http://www.ruby-doc.org/core/

Also, Ruby documentation can be found at http://www.ruby-lang.org/ including:

* The Learning Ruby (Pickaxe) Book: http://www.ruby-doc.org/docs/ProgrammingRuby/
* Learn to Program: http://pine.fm/LearnToProgram/  (a beginners guide)

These two online (and free) books will bring you up to speed on the Ruby language
and also on programming in general.


== Debugger

Debugger support is available through the debugger command when you start your Mongrel or
Webrick server with --debugger. This means that you can break out of execution at any point
in the code, investigate and change the model, AND then resume execution! 
You need to install ruby-debug to run the server in debugging mode. With gems, use ''gem install ruby-debug''
Example:

  class WeblogController < ActionController::Base
    def index
      @posts = Post.find(:all)
      debugger
    end
  end

So the controller will accept the action, run the first line, then present you
with a IRB prompt in the server window. Here you can do things like:

  >> @posts.inspect
  => "[#<Post:0x14a6be8 @attributes={\"title\"=>nil, \"body\"=>nil, \"id\"=>\"1\"}>,
       #<Post:0x14a6620 @attributes={\"title\"=>\"Rails you know!\", \"body\"=>\"Only ten..\", \"id\"=>\"2\"}>]"
  >> @posts.first.title = "hello from a debugger"
  => "hello from a debugger"

...and even better is that you can examine how your runtime objects actually work:

  >> f = @posts.first
  => #<Post:0x13630c4 @attributes={"title"=>nil, "body"=>nil, "id"=>"1"}>
  >> f.
  Display all 152 possibilities? (y or n)

Finally, when you''re ready to resume execution, you enter "cont"


== Console

You can interact with the domain model by starting the console through <tt>script/console</tt>.
Here you''ll have all parts of the application configured, just like it is when the
application is running. You can inspect domain models, change values, and save to the
database. Starting the script without arguments will launch it in the development environment.
Passing an argument will specify a different environment, like <tt>script/console production</tt>.

To reload your controllers and models after launching the console run <tt>reload!</tt>

== dbconsole

You can go to the command line of your database directly through <tt>script/dbconsole</tt>.
You would be connected to the database with the credentials defined in database.yml.
Starting the script without arguments will connect you to the development database. Passing an
argument will connect you to a different database, like <tt>script/dbconsole production</tt>.
Currently works for mysql, postgresql and sqlite.

== Description of Contents

app
  Holds all the code that''s specific to this particular application.

app/controllers
  Holds controllers that should be named like weblogs_controller.rb for
  automated URL mapping. All controllers should descend from ApplicationController
  which itself descends from ActionController::Base.

app/models
  Holds models that should be named like post.rb.
  Most models will descend from ActiveRecord::Base.

app/views
  Holds the template files for the view that should be named like
  weblogs/index.html.erb for the WeblogsController#index action. All views use eRuby
  syntax.

app/views/layouts
  Holds the template files for layouts to be used with views. This models the common
  header/footer method of wrapping views. In your views, define a layout using the
  <tt>layout :default</tt> and create a file named default.html.erb. Inside default.html.erb,
  call <% yield %> to render the view using this layout.

app/helpers
  Holds view helpers that should be named like weblogs_helper.rb. These are generated
  for you automatically when using script/generate for controllers. Helpers can be used to
  wrap functionality for your views into methods.

config
  Configuration files for the Rails environment, the routing map, the database, and other dependencies.

db
  Contains the database schema in schema.rb.  db/migrate contains all
  the sequence of Migrations for your schema.

doc
  This directory is where your application documentation will be stored when generated
  using <tt>rake doc:app</tt>

lib
  Application specific libraries. Basically, any kind of custom code that doesn''t
  belong under controllers, models, or helpers. This directory is in the load path.

public
  The directory available for the web server. Contains subdirectories for images, stylesheets,
  and javascripts. Also contains the dispatchers and the default HTML files. This should be
  set as the DOCUMENT_ROOT of your web server.

script
  Helper scripts for automation and generation.

test
  Unit and functional tests along with fixtures. When using the script/generate scripts, template
  test files will be generated for you and placed in this directory.

vendor
  External libraries that the application depends on. Also includes the plugins subdirectory.
  If the app has frozen rails, those gems also go here, under vendor/rails/.
  This directory is in the load path.
