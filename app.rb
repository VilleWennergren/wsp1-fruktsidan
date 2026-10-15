class App < Sinatra::Base
  register Sinatra::Reloader

  def db
    return @db if @db

    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true
    @db
  end

  get '/fruits' do
    @fruits = db.execute('SELECT * FROM products ORDER BY name')
    erb(:"fruits/index")
  end

  get '/fruits/new' do
    @categories = db.execute('SELECT * FROM categories ORDER BY name')
    erb(:"fruits/new")
  end

  post '/fruits' do
    category_id = params['category_id'].to_s.empty? ? nil : params['category_id']
    db.execute(
      'INSERT INTO products (name, description, tastiness, category_id) VALUES (?, ?, ?, ?)',
      [
        params['fruit_name'],
        params['fruit_description'],
        params['fruit_tastiness'],
        category_id
      ]
    )
    redirect('/fruits')
  end

  get '/fruits/:id' do |id|
    @fruit = db.execute('SELECT * FROM products WHERE id = ?', id).first
    halt 404 unless @fruit

    @category = db.execute(
      'SELECT * FROM categories WHERE id = ?',
      @fruit['category_id']
    ).first
    erb(:"fruits/show")
  end

  get '/fruits/:id/edit' do |id|
    @fruit = db.execute('SELECT * FROM products WHERE id = ?', id).first
    halt 404 unless @fruit

    @categories = db.execute('SELECT * FROM categories ORDER BY name')
    erb(:"fruits/edit")
  end

  post '/fruits/:id/edit' do |id|
    category_id = params['category_id'].to_s.empty? ? nil : params['category_id']
    db.execute(
      'UPDATE products SET name = ?, description = ?, tastiness = ?, category_id = ? WHERE id = ?',
      [
        params['fruit_name'],
        params['fruit_description'],
        params['fruit_tastiness'],
        category_id,
        id
      ]
    )
    redirect('/fruits')
  end

  post '/fruits/:id/delete' do |id|
    db.execute('DELETE FROM products WHERE id = ?', id)
    redirect('/fruits')
  end

  get '/categories' do
    @categories = db.execute('SELECT * FROM categories ORDER BY name')
    erb(:"categories/index")
  end

  get '/categories/:id' do |id|
    @category = db.execute('SELECT * FROM categories WHERE id = ?', id).first
    halt 404 unless @category

    @fruits = db.execute(
      'SELECT * FROM products WHERE category_id = ? ORDER BY name',
      id
    )
    erb(:"categories/show")
  end
end
