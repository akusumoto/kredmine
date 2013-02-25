  def flowplayer_open( file, poster="")
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
  