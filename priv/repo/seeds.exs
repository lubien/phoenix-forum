alias PhoenixForum.Repo
alias PhoenixForum.Forum.Thread
alias PhoenixForum.Forum.Comment

lorem =
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla commodo elit nec lobortis sodales. Praesent euismod diam justo, a posuere neque congue a. Vestibulum vitae sapien lectus. Proin fringilla finibus velit, ut ullamcorper diam consectetur ac. Nulla tempus justo dignissim quam auctor fermentum eget a nibh. Duis at lacinia sem. Cras sagittis ex vitae leo ultrices, id tempus tortor lacinia. Aliquam sit amet imperdiet enim, nec blandit nunc. Duis facilisis massa non sodales mattis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Etiam ultricies, nisi eget facilisis venenatis, nibh nibh facilisis nibh, sed venenatis nunc mauris non lectus. Nam in arcu odio. Praesent vitae nulla iaculis, consequat justo at, feugiat nunc."

authors = ["Lubien", "Fulano", "Ciclano", "Beltrano"]

for i <- 1..100 do
  thread =
    Repo.insert!(%Thread{
      title: "Auto Generated #{i}",
      content: lorem,
      author: Enum.random(authors)
    })

  for j <- 1..Enum.random(2..5) do
    Repo.insert!(%Comment{
      thread_id: thread.id,
      content: lorem,
      author: Enum.random(authors)
    })
  end
end
