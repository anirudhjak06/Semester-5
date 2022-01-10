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

const ProjectDetails = `Create table if not exists S20190010007(
    pid Integer Primary key Autoincrement,
    pname varchar(50) not null,
    rollno char(12) not null,
    semester varchar(4) not null,
    pdetails varchar(100),
    techused varchar(25)
);`

db.run(ProjectDetails,err=>{
    if(err){
        return console.log(err.message)
    }
    console.log("S20190010007 table created successfully")
})

app.get('/', (req,res)=>{
    res.render("home")
})

app.get('/AddProjectDetails',(req,res)=>{
    res.render('addprojectdetails')
})

app.post('/Form',(req,res)=>{
    const sql = `Insert into S20190010007 (pname,rollno,semester,pdetails,techused) Values (?,?,?,?,?)`
    const book = [req.body.pname, req.body.rollno, req.body.sem, req.body.pdetails, req.body.techused]
    db.run(sql,book,err=>{
        if(err){
            return console.log(err.message)
        }
        res.redirect('/')
    })
})

app.get('/ProjectDetails',(req,res)=>{
    const sql = "Select * from S20190010007"
    db.all(sql,(err,rows)=>{
        if(err){
            return console.log(error)
        }
        res.render('projectdetails',{model:rows})
    })
})

app.get('/ContactUs',(req,res)=>{
    res.render('contactus')
})
