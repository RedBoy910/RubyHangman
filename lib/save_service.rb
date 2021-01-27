require 'yaml'

module SaveService

  def self.load_save
    puts 'Choose one of the available saves:'
    Dir.foreach 'saves' do |file|
      if !['.', '..'].include? file
        puts file
        puts '---'
      end
    end

    input = gets.chomp

    path = 'saves/' + input.strip
    #puts path

    until File.exist? path
      puts 'Invalid choice, try again'
      input = gets.chomp
      path = 'saves/' + input.strip
      #puts path
    end

    YAML.load(File.read(path))
  end

  def self.make_save(name, instance)
    filename = "saves/#{name}"

    #puts filename

    File.new(filename, 'w')

    File.open(filename, 'w') do |file|
      file.write(YAML.dump(instance))
    end
  end

  def self.generate_word
    random_word = ''

    file = '5desk.txt'

    File.open(file, 'r') do |file|
      file_lines = file.readlines

      until 5 <= random_word.size && random_word.size <= 12 do
        random_word = file_lines[Random.rand(0...file_lines.size)]
  
        random_word = random_word.split.select{|it| it.match(/[a-zA-Z]/)}
        random_word = random_word.join
        random_word = random_word.to_s.downcase.strip
      end
    end

    random_word
  end
end
