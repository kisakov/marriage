require 'rubygems'
require 'sinatra'
require 'dm-core' # ядро
require 'dm-validations' # валидации (not_null и тому подобное)
require 'dm-timestamps' # автоматическое проставление времени создания и обновления для записей
require 'dm-migrations'
require 'init'
require 'marriage'

msg = String.new
persona_info = Hash.new

get '/' do
  @person = Person.all
  @marriage = Marriage.all
  erb :list # Рендерим шаблон
end

get '/person/list' do
  'Show users'
end

get '/person/new' do
  @msg = msg
  msg = ''
  @form_action="create"
  @title="Создать персону"
  persona_info.clear if @msg == ''
  @persona = persona_info

  erb :form_person
end

post '/person/create' do
  @persona = Person.new(:last_name => params[:last_name], :first_name => params[:first_name], :sex => params[:sex], :age => params[:age], :marriage => params[:marriage])
  if @persona.save
    redirect '/' # редирект на главную
  else
    msg = '<span class="error">Не все поля заполнены или не правильный формат</span>'
    persona_info = params
    redirect '/person/new'
    #@persona.errors.each do |e|
    #  puts e
    #end
  end
end

get '/person/edit/:id' do
  @msg = msg
  msg = ''
  @form_action="update"
  @title="Отредактировать персону"
  persona_info.clear if @msg == ''
  if @msg == ''
    @persona = Person.get(params[:id])
  else
    @persona = persona_info
  end

  erb :form_person
end

post '/person/update' do
  persona = Person.get(params[:id])
  if persona.update(:last_name => params[:last_name], :first_name => params[:first_name], :sex => params[:sex], :age => params[:age])
    redirect '/' # редирект на главную
  else
    msg = '<span class="error">Не все поля заполнены или не правильный формат</span>'
    persona_info = params
    redirect '/person/new'
  end
end

get '/person/delete/:id' do
  person = Person.get(params[:id])
  if person.sex == "муж" && person.marriage
    marry = Marriage.first(:groom_id => params[:id])
    Person.get(marry.bride_id).update(:marriage => false)
    marry.destroy
  elsif person.sex == "жен" && person.marriage
    marry = Marriage.first(:bride_id => params[:id])
    Person.get(marry.groom_id).update(:marriage => false)
    marry.destroy
  end
  person.destroy
  redirect '/' # редирект на главную
end

helpers do
  #Возвращает семейное положение
  def stat(sex, marriage)
    if sex == "муж"
        if marriage
          "женат"
        else
           "не женат"
        end
    else
        if marriage
          "замужем"
        else
          "не жената"
        end
    end
  end

  #Возвращает полное имя для таблицы свадеб
  def get_name(id)
    "#{Person.get(id).last_name} #{Person.get(id).first_name[0, 2]}."
  end

end
