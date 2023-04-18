# Some random application for managing wallpapers.

## TODO
- ~~Fix file extensions~~
- Add 'query' operation to query files based on tags and maybe some other things.
- What 'query' should be able to do:
  - List all files
  - List images by some criteria ( resolution, tags, name ) 
- A~~dd 'index fix'. Not all wallpapers will be removed by this app, there could be some others scripts running. So 'index fix' would fix metadata in index.csv for missing files~~
- Fix logging. Do some proper info/debug/error redirects into files
- Do something about tag names. Currently it is easy to misspell tag names and its annoying. Maybe some file that would store available tags.
- 'download' should be able to resize downloaded images. Add flag and prompt for resizing
- Extend 'remove' functionality. Add option to remove multiple files by name or by id range.
- Add option to download image straight from reddit post. This would allow to save the post url for credits. Credits would also go into index.csv probably. ( Will require some scrapping to get the image URL )
- Reddit have api to upvote or downvote posts. 'download' could also auto upvote ( Of course it should be opt in by some env variable or prompt)
- 