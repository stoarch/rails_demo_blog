# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

DEFAULT_PASSWORD = '123456'

LOREM_IPSUM = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit purus ex, sit amet mattis augue tincidunt dignissim. Ut vestibulum volutpat diam at pretium. Fusce dapibus posuere auctor. Ut quis pretium sem. Duis ac ligula sagittis, pulvinar sapien id, posuere dui. Morbi cursus vehicula euismod. Vestibulum purus lorem, mattis ac porta non, congue et lectus. Sed ultrices sapien ligula, ut dignissim quam faucibus at. Proin velit tellus, condimentum non mollis sit amet, rhoncus et augue. Aliquam erat volutpat.  Sed sit amet quam sed purus feugiat sollicitudin at nec est. Ut at congue risus, a auctor sem. Duis sed mauris lorem. Integer dapibus lectus bibendum nibh cursus, et tincidunt augue pharetra. Pellentesque volutpat nibh eu dui sagittis viverra. Phasellus massa orci, bibendum quis consequat ut, volutpat ac lorem. Donec nunc neque, viverra vel cursus ac, viverra in elit. Nulla id volutpat neque, at feugiat lacus. Donec mollis nisi at risus dapibus vestibulum. Ut egestas sed sem vitae sagittis. Integer eu odio vitae elit sodales maximus. Maecenas vel turpis massa.  Etiam aliquet purus vitae erat semper ullamcorper. Donec massa nibh, bibendum ut neque ut, lacinia faucibus tellus. Vestibulum vitae quam odio. Ut convallis nisi sapien, at pharetra quam elementum eget. Suspendisse nisl massa, efficitur quis eleifend id, iaculis quis erat. Fusce ultrices erat in diam imperdiet aliquam. Morbi maximus est massa, vel porttitor massa ultrices sit amet. Aenean fermentum libero sit amet tellus eleifend posuere. In mauris odio, porta non pretium nec, fringilla eu nisi. Vivamus sollicitudin nisi non egestas ultrices. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed fringilla leo sit amet enim finibus ultricies. Donec faucibus dictum pretium.  In euismod augue a justo consectetur, bibendum interdum lorem tristique. Donec et interdum ipsum. Nulla quis eleifend tellus. Duis congue aliquet eros. Fusce vitae convallis tellus. Integer ultricies commodo nisl, et blandit neque consequat et. Vestibulum a vulputate tortor. In interdum sollicitudin sapien, nec fermentum erat dapibus in. Curabitur et quam sodales, lacinia tellus et, fermentum odio. Etiam vel eros id sapien laoreet ultricies. Donec molestie lacus placerat lectus blandit consectetur. Proin malesuada lorem nec sapien congue, eu fermentum ex pulvinar. Quisque a massa fermentum, dictum nulla venenatis, efficitur mauris.  Integer ac nisl sit amet turpis suscipit facilisis vel vitae metus. Fusce mattis mi ac urna consequat, non porttitor ipsum gravida. Ut tortor nisi, iaculis eget lacus non, tempor hendrerit lectus. Phasellus quis malesuada lorem. Morbi lacinia justo sit amet consectetur blandit. Proin non mollis libero. Nullam interdum posuere arcu, et finibus ligula bibendum ac. Pellentesque auctor velit dolor, id egestas metus consequat in. Sed mollis, lacus id posuere dapibus, orci eros fringilla ipsum, eu dapibus sapien ex eget nunc. Vivamus consequat aliquam velit eget pulvinar. Maecenas convallis interdum neque, quis cursus leo aliquam vitae. Sed velit arcu, pulvinar ut fringilla nec, laoreet tempus urna. Aenean tempor eros in nibh ultrices dapibus.'

author_templates = [
  {full_name: 'John Doe', birth_date: Date.new(1980,1,1), email: 'john@example.com', password: DEFAULT_PASSWORD },
  {full_name: 'Nick Warren', birth_date: Date.new(1981,2,1), email: 'nick@example.com', password: DEFAULT_PASSWORD },
  {full_name: 'Loren Straight', birth_date: Date.new(1982,3,1), email: 'loren@example.com', password: DEFAULT_PASSWORD },
  {full_name: 'Paul Smith', birth_date: Date.new(1988,5,1), email: 'paul@example.com', password: DEFAULT_PASSWORD }
]

authors = []

author_templates.each_with_index do |at, i|
  author = Author.where(full_name: at[:full_name]).first_or_create(at)
  authors << author 
  if author.user.nil?
    user = User.where(email: at[:email]).first_or_create(email: at[:email], password: at[:password])
    author.user = user
  end

  2.times do |j|
    post_title = "Post #{i*2+j}"
    author.posts.where(title: post_title).first_or_create(title: post_title, content: LOREM_IPSUM )
  end

  author.save
end

