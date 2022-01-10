http = require('http') 
express = require('express')
path = require('path')

const sqlite3 = require('sqlite3')
const bparser = require('body-parser')

const app = express()
const port = 8055

app.use(bparser.urlencoded({extended:false}))

app.listen(port,()=>{
    console.log(`Server is running on ${port}`)
})

app.set('view engine','ejs')
app.set('views',path.join(__dirname,'views'))

const db_name = path.join(__dirname,'data',"app.db")
const db = new sqlite3.Database(db_name,err=>{
    if(err){
        return console.log(err.message)
    }
    console.log("Database Connected app.db")
})

const ProjectDetails = `Create table if not exists Entry(
    pid Integer Primary key Autoincrement,
    sqltime TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    age int not null,
    education varchar(20) not null,
    country varchar(20) not null,
    issue varchar(100),
    imp varchar(100) not null,
    cause varchar(100),
    impact varchar(100),
    tackle varchar(100),
    action varchar(100) not null
);`

db.run(ProjectDetails,err=>{
    if(err){
        return console.log(err.message)
    }
    console.log("Entry table created successfully")
})

app.get('/', (req,res)=>{
    res.render("home")
})

app.get('/AddClimateDetails',(req,res)=>{
    res.render('addclimatedetails')
})

app.post('/Form',(req,res)=>{
    const sql = `Insert into Entry (age,education,country,issue,imp,cause,impact,tackle,action) Values (?,?,?,?,?,?,?,?,?)`
    const book = [req.body.age, req.body.education, req.body.country, req.body.issue,req.body.imp,req.body.cause,req.body.impact,req.body.tackle,req.body.action]
    db.run(sql,book,err=>{
        if(err){
            return console.log(err.message)
        }
        res.redirect('/')
    })
})

app.get('/ClimateDetails',(req,res)=>{
    const sql = "Select * from Entry"
    db.all(sql,(err,rows)=>{
        if(err){
            return console.log(error)
        }
        res.render('climatedetails',{model:rows})
    })
})

app.get('/SortDetails',(req,res)=>{
    const sql = "Select * from Entry ORDER BY sqltime DESC"
    db.all(sql,(err,rows)=>{
        if(err){
            return console.log(error)
        }
        res.render('climatedetails',{model:rows})
    })
})

app.get('/ContactUs',(req,res)=>{
    res.render('contactus')
})
