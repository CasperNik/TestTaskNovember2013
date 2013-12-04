class WelcomeController < ApplicationController

  # default root
  def index

  end

  # gets all the tags in the text as an array
  # and returns the result of the test according to set parameters in the task.
  def check
    tags = params[:text].scan(/<(\/?[A-Z])>/).flatten # array of tags
    if !tags[0]                                       # check in case the entered text is empty or does not contain the required tags
      render text: "Doesn't exist any tags in text."
    else
      previous = ''
      begin                                           # start checking the tags
        while tags.count > 0
          tags.each do |tag|
            previous_opened = previous[0] != '/'
            current_closed = tag[0].eql? '/'
            if previous_opened and current_closed
              unless previous.eql? tag[1..-1]
                raise StandardError, "Expected &lt;/#{previous}&gt; found &lt;#{tag}&gt;"
              else
                tags.delete previous                 #  delete used tags
                tags.delete tag                      #
              end
            elsif current_closed
              raise StandardError, "Expected # found &lt;#{tag}&gt;"
            end

            if tags.count == 1
              raise StandardError, "Expected &lt;/#{tag}&gt; founded #" unless current_closed
            end

            previous = tag
          end
        end                                            # end while
      raise StandardError, "Correctly tagged paragraph"

      rescue StandardError => e                        # returns the result
        render text: e.message
      end                                              # finish begin
    end
  end

end
