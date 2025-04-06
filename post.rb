class Post

  def initialize
    @created_at = Time.now
    @text = []
  end

  def self.post_types
    [Memo, Task, Link]
  end

  def self.create(type_index)
    return post_types[type_index].new
  end  


  def read_from_console
    # Этот метод должен быть реализован у каждого ребенка, так как именно они
    # знают, как именно считывать свои данные из консоли.
  end


  def to_strings
    # Этот метод должен быть реализован у каждого ребенка, так как именно они
    # знают как именно хранить перевести себя в массив строк.
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
end