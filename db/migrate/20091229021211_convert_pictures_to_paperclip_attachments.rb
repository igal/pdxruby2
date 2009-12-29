class ConvertPicturesToPaperclipAttachments < ActiveRecord::Migration
  def self.up
    old_images_directory = "#{RAILS_ROOT}/public/images/members"
    if File.directory?(old_images_directory)
      puts "* Migrating old images to PaperClip attachments:"
      for old_image_file in Dir.glob("#{old_images_directory}/*")
        if member_id = old_image_file[/\/(\d+)\.\w+$/, 1]
          begin
            member = Member.find(member_id)
            handle = File.open(old_image_file)
            member.picture = handle
            member.save!
            puts "- Added picture for Member #{member_id}"
          rescue ActiveRecord::RecordNotFound => e
            puts "- WARNING: Found file but not record for Member #{member_id}"
          end
        else
          puts "- WARNING: Skipped unknown file `#{File.basename(old_image_file)}`"
        end
      end
    end
  end

  def self.down
  end
end
