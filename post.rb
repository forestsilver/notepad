require 'sqlite3'
require 'date'


class Post

  @@AQLITE_DB = 'C:/PHealth/Ruby_learn/nasledovanie/notepad/notepad.db'

  def initialize
    @created_at = Time.now
    @text = []
  end

  def self.post_types
    {'Memo' => Memo,'Task' => Task, 'Link' => Link}
  end

  def self.create(type)
    return post_types[type].new
  end  


  def read_from_console
    # Этот метод должен быть реализован у каждого ребенка, так как именно они
    # знают, как именно считывать свои данные из консоли.
  end


  def to_strings
    # Этот метод должен быть реализован у каждого ребенка, так как именно они
    # знают как именно хранить перевести себя в массив строк.
  end

  def self.find_id(limit, type, id)
    if !id.nil?
      db = SQLite3::Database.open(@@AQLITE_DB)
      db.results_as_hash = true
      
      result = db.execute('SELECT * FROM posts WHERE rowid = ?', id).first
      db.close
      
      if result.nil?
        puts "Такой id #{id} не найден в базе :("
        return nil
      else
        post = create(result['type'])
        post.load_data(result)
        post
      end
    else
      find_all(limit, type) # Теперь этот метод точно вернет массив
    end
  end

  def self.find_all(limit, type)
    db = SQLite3::Database.open(@@AQLITE_DB)
    db.results_as_hash = false
    
    query = 'SELECT rowid, * FROM posts '
    query += 'WHERE type = ? ' unless type.nil?
    query += 'ORDER by rowid DESC '
    query += 'LIMIT ? ' unless limit.nil?
  
    # Подготавливаем параметры для запроса
    params = []
    params << type unless type.nil?
    params << limit.to_i unless limit.nil?
  
    # Выполняем запрос и сразу получаем массив результатов
    result = db.execute(query, *params)
    
    db.close
    result # Возвращаем массив с результатами
  end

  def load_data(data_hash)
    @created_at = DateTime.parse(data_hash['created_at'])
    @text = data_hash['text']
  end

  
  def save
  
    file = File.new(file_path, "w:UTF-8") 

    for item in to_strings do 
      file.puts(item)
    end

    file.close
  end

  # Метод file_path общий для всех классов, он возвращающает путь к файлу, куда
  # записывать текущий экземпляр.
  def file_path
    # Сохраним в переменной current_path место, откуда запустили программу
    current_path = File.dirname(__FILE__)

    # Получим имя файла из даты создания поста и названия класса. Метод strftime
    # формирует строку типа "2016-12-27_12-08-31.txt". Обратите внимание, мы
    # добавили в название файла даже секунды (%S) — это обеспечит уникальность
    # мени файла. А с помощью метода class, вызванного у экземпляра класса
    # мы получим нужный класс, чтобы файл назывался, например:
    #
    # link_2016-12-27_12-08-31.txt
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    # Склеиваем путь из относительного пути к папке и названия файла
    current_path + '/' + file_name
  end

  def save_to_db
    db = SQLite3::Database.open(@@AQLITE_DB)
    db.results_as_hash = true

    db.execute(
      "INSERT INTO posts (" + 
      to_db_hash.keys.join(',') + 
      ")" +
      " VALUES (" + 
      ('?,'*to_db_hash.keys.size).chomp(',') + 
      ") ",
      to_db_hash.values
    )

    

    insert_raw_id = db.last_insert_row_id
    db.close
    return insert_raw_id

    

  end

  def to_db_hash
    {
      'type' => self.class.name,
      'created_at' => @created_at.to_s
    }
  end



end