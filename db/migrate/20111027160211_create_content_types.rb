class CreateContentTypes < ActiveRecord::Migration
  def change
    create_table :content_types do |t|
	  t.string :type_name
      t.timestamps
    end
	
	ContentType.create :type_name => "Pic"
	ContentType.create :type_name => "Rant"
	ContentType.create :type_name => "Code"
	ContentType.create :type_name => "Blog"
	ContentType.create :type_name => "Link"
	ContentType.create :type_name => "Question"
  end
end
