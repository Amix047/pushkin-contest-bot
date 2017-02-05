   TOKEN=''
   WORD="А-Яа-яЁё0-9"
   ADDR=URI("http://pushkin.rubyroidlabs.com/quiz")

    def normalize(string)
      downcase = string.mb_chars.downcase
      spaces = downcase.gsub(/\A[[:space:]]*/, '').gsub(/[[:space:]]{2,}/, ' ').gsub(/[[:space:]]*\z/, '')
      del_simbols(spaces)
    end

    def del_simbols(line)
      line.gsub(/[\!\*\(\)\-\=\№\;\?\,\.\'\[\]\\\:\"\<\>\—]/,'').to_s
    end

    poems = JSON.parse(File.read(File.expand_path('../../../db/poems-full.json', __FILE__)))
    $data_1 = Hash[poems.flat_map {|name, lines| lines.map {|line| [normalize(line), name]  }}]

    all_lines = poems.map {|name, lines| lines }.flatten.map{|line| normalize(line) }

    $data_2345 = {}
    all_lines.each do |line|
      words = line.split(/\s+/).map {|word| normalize(word)}
      words.each {|word| $data_2345[line.sub(word, '%word%')] = word }
    end

    $data_67 = {}
    all_lines.each{|line| $data_67[normalize(line).chars.sort]= line}

    $data_8 = {}
    poems.map{|x| x[1]}.flatten.uniq.each do |x|
      letters = del_simbols(x).chars
      $data_8[letters.size]||={}
      $data_8[letters.size][letters] = x
    end
