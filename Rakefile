require 'rake'

namespace :build do
  task :dev do
    content = File.read("dev/base.html")
    content.gsub!("<!-- CODE GOES HERE -->", "<script type=\"text/javascript\" src=\"http://cdnjs.cloudflare.com/ajax/libs/coffee-script/1.1.2/coffee-script.min.js\"></script>
<script type=\"text/coffeescript\" src=\"../src/ypresenter.coffee\"></script>")
    File.open("dev/index.html", "w") do |f|
      f.write(content)
    end
  end

  task :release do
    `coffee -c -o lib/ src/ypresenter.coffee`
    content = File.read("dev/base.html")
    content.gsub!("<!-- CODE GOES HERE -->", "<script type=\"text/javascript\" src=\"../lib/ypresenter.js\"></script>")
    File.open("examples/index.html", "w") do |f|
      f.write(content)
    end
  end
end
