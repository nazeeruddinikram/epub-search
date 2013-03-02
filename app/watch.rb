class Watch
  def initialize(db_path, directory_path)
    @db_path, @directory = db_path, Pathname(directory_path)
  end

  def run
    Listen.to @directory.to_path, :filter => /\.epub\Z/ do |modified, added, removed|
      modified.each do |file_path|
        file_path.force_encoding 'UTF-8'
        begin
          Remove.new(@db_path, file_path).run
          Add.new(@db_path, file_path).run
          notify %Q|EPUB MODIFIED: #{file_path}|
        rescue => error
          $stderr.puts error
        end
      end
      added.each do |file_path|
        file_path.force_encoding 'UTF-8'
        begin
          Add.new(@db_path, file_path).run
          notify %Q|EPUB ADDED: #{file_path}|
        rescue => error
          $stderr.puts error
        end
      end
      removed.each do |file_path|
        file_path.force_encoding 'UTF-8'
        begin
          Remove.new(@db_path, file_path).run
          notify %Q|EPUB REMOVED: #{file_path}|
        rescue => error
          $stderr.puts error
        end
      end
    end
  end

  private

  def notify(message)
    $stderr.puts message
    `notify-send #{message.shellescape}`
  end
end
