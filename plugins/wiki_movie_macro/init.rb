require 'redmine'

Redmine::Plugin.register :wiki_movie_macro do
  name 'Wiki Movie Macro plugin'
  author 'ituki_yu'
  description 'Support Wiki Movie Macro'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://itukiyou.dousetsu.com/'
end


Redmine::WikiFormatting::Macros.register do
  macro :wiki_movie do |obj, args|
    word = args.first
    word = "../../files/"+ CGI.escape(word)
    file = word
    poster = word
    ext = Pathname.new(file).extname
    fp_template = <<EOS
      <div id="video" class="flowplayer" data-swf="/flowplayer-5.swf" >
      <video poster="#{poster}">
      <source type="video/#{ext}" src="#{file}" />
      </video>
      </div>
      <script type="text/javascript">
      $(".player").flowplayer("path/to/flowplayer.swf", function(e, api) {
 
      });
      </script>
EOS
    raw fp_template
    
  end
end
