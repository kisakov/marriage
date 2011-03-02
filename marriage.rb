msg = String.new
persona_info = Hash.new

get '/marriage/new' do
  @msg = msg
  msg = ''
  @form_action="create"
  @title="Сыграть свадьбу"
  @suitors = Person.all(:sex => "муж", :marriage => false)
  @brides = Person.all(:sex => "жен", :marriage => false)
  persona_info.clear if @msg == ''
  @marriage = persona_info
  erb :form_marriage
end

post '/marriage/create' do
  marriage = Marriage.new(:groom_id => params[:groom_name], :bride_id => params[:bride_name], :music => params[:music], :flowers => params[:flowers],  :guests => params[:guests])

  if marriage.save
    
    Person.get(params[:groom_name]).update(:marriage => true)
    Person.get(params[:bride_name]).update(:marriage => true)

    redirect '/'
  else
    msg = '<span class="error">Не все поля заполнены или не правильный формат</span>'
    persona_info = params
    redirect '/marriage/new'
  end

end

get '/marriage/edit/:id' do
  @msg = msg
  msg = ''
  @form_action="update"
  @title="Отредактировать свадьбу"
 
  persona_info.clear if @msg == ''
  if @msg == ''
    @marriage = Marriage.get(params[:id])
  else
    @marriage = persona_info
  end

  erb :form_marriage
end

post '/marriage/update' do
  marriage = Marriage.get(params[:id])
  if marriage.update(:groom_id => params[:groom_name], :bride_id => params[:bride_name], :music => params[:music], :flowers => params[:flowers],  :guests => params[:guests])
    redirect '/' # редирект на главную
  else
    msg = '<span class="error">Не все поля заполнены или не правильный формат</span>'
    persona_info = params
    redirect '/person/new'
  end
end

get '/marriage/delete/:id' do
  marry = Marriage.get(params[:id])
  Person.get(marry.groom_id).update(:marriage => false)
  Person.get(marry.bride_id).update(:marriage => false)
  marry.destroy
  redirect '/' # редирект на главную
end