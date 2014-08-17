express    = require 'express'
compress   = require 'compression'
bodyParser = require 'body-parser'
logger     = require 'morgan'
path       = require 'path'
port       = process.env.PORT or 3001

app = express()

app.use compress()
app.use bodyParser.json()
app.use express.static (path.resolve "bin")
app.use logger 'dev'

app.set 'views', __dirname + 'src/'
app.set 'view engine', 'jade'
app.get '/', (req, res) -> res.render 'index'

app.listen port
