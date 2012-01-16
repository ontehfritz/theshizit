class CreateTones < ActiveRecord::Migration
  def change
    create_table :tones do |t|
      t.string :mood
      t.timestamps
    end
    
    Tone.create :mood => "Normal"
    Tone.create :mood => "Fo Shizzle"
    Tone.create :mood => "Sad"
    Tone.create :mood => "Raging"
    Tone.create :mood => "Sarcastic"
    Tone.create :mood => "Huh?"
    
  end
end
