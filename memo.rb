class Memo < Post
  # Отдельный конструктор здесь не нужен, т. к. у заметки нет дополнительных
  # переменных экземпляра.


  def read_from_console
    puts "Я сохраню всё, что ты напишешь до строчки \"end\" в файл."

    # Объявим переменную, которая будет содержать текущую введенную строку
    line = nil

    # Запустим цикл, пока не дошли до строчки "end",
    while line != "end" do
      # Читаем очередную строку и записываем в массив @text
      line = STDIN.gets.chomp
      @text << line
    end

    # Теперь удалим последний элемент из массива @text – там служебное слово "end"
    @text.pop
  end

  def save
    # Откроем файл для записи в режиме записи (write)
    # Файл не существует и будет создан
    file = File.new(file_path, "w:UTF-8")

    # Обратите внимание, что мы вызвали метод file_name, который определили выше
    # save и file_name — методы одного класса и поэтому могут использовать друг друга

    # Сперва запишем в блокнот дату и время записи и сделаем отступ
    # \r – специальный дополнительный символ конца строки для Windows
    time_string = @created_at.strftime("%Y.%m.%d, %H:%M")
    file.puts(time_string + "\n\r")

    # Затем в цикле запишем в файл строчку за строчкой массив @text
    for item in @text do
      # Метод puts добавляет перевод строки в конце, что нам и надо
      file.puts(item)
    end

    # Обязательно закрыть файл, чтобы сохранить все изменения
    file.close

    # Напишем пользователю, что запись добавлена
    puts "Ваша запись сохранена"
  end

  def load_data(data_hash)
    super(data_hash)

    @text = data_hash['text'].split('\n')
  end


  def to_strings
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')}\n"

    @text.unshift(time_string)
  end

  
  def to_db_hash
    return super.merge(
      {
        'text' => @text.join('\n\r')
      }
    )
  end
end