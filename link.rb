
class Link < Post
  # Конструктор у класса «Ссылка» свой, но использует конструктор родителя.
  def initialize
    # Вызываем конструктор родителя
    super

    # Создаем специфичную для ссылки переменную экземпляра @url — адрес, куда
    # будет вести ссылка.
    @url = ''
  end

  # Этот метод пока пустой, он будет спрашивать ввод содержимого Ссылки
  def read_from_console
    puts "Введите адрес ссылки"
    @url = STDIN.gets.chomp

    puts "Напишите пару слов о том куда ведет ссылка"
    @text = STDIN.gets.chomp
  end

  # Этот метод будет возвращать массив из трех строк: адрес ссылки, описание
  # и дата создания
  def save
    file = File.new(file_path, "w:UTF-8")
    time_string = @created_at.strftime("%Y.%m.%d, %H:%M")
    file.puts(time_string + "\n\r")

    file.puts(@url)
    file.puts(@text)

    file.close
    puts "Ваша ссылка сохранена"

  end
end