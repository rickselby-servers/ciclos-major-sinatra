# frozen_string_literal: true

# Helpers for rake tasks
module RakeHelpers
  module_function

  def node_command(command, name: nil)
    flags = [
      "--rm",
      "-i",
      "-v #{Dir.pwd}:/app",
      "-w /app",
      "--env HOME=./.node",
      "--user #{Process.uid}:#{Process.gid}",
    ]
    flags.push "--name #{name}" unless name.nil?

    "docker run #{flags.join " "} node:16-alpine #{command}"
  end

  def resize_photos(directory, size)
    FileUtils.cd directory do
      Rake.sh "pwd"
      Rake.sh %(find . -name "*.JPG" -exec bash -c 'mv "$0" "${0%.JPG}.jpg"' {} \\;)
      Rake.sh "mogrify -auto-orient *"
      Rake.sh "mogrify -resize #{size} *"
      Rake.sh "git add *"
    end
  end
end
