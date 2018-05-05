package main

import (
	"database/sql"
	"net/http"
	"os"
	"path/filepath"
	"time"

	_ "github.com/go-sql-driver/mysql"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	id        int
	name      string
	email     string
	password  string
	createdAt time.Time
	updateAt  time.Time
	deletedAt time.Time
}

func main() {
	db, err := sql.Open("mysql", "root:1234@/go")
	r := gin.Default()

	if err != nil {
		panic(err.Error()) // Just for example purpose. You should use proper error handling instead of panic
	}
	defer db.Close()

	r.LoadHTMLGlob(filepath.Join(os.Getenv("GOPATH"), "templates/index.tmpl"))
	// r.GET("/", func(c *gin.Context) {
	// 	c.JSON(200, gin.H{
	// 		"Hello": "World",
	// 	})
	// })

	r.GET("/", indexRouter)

	r.POST("/user", createUser(db))
	r.POST("/user/login", loginUser(db))

	r.GET("/board", findAllBoard)
	r.POST("/board", createBoard)
	r.PUT("/board/:id", updateBoard)
	r.DELETE("/board/:id", deleteBoard)

	r.Run(":3000")
}

func indexRouter(c *gin.Context) {
	c.HTML(http.StatusOK, "index.tmpl", gin.H{
		"title": "Main website",
	})
}
func createUser(d *sql.DB) func(c *gin.Context) {

	return func(c *gin.Context) {
		name, _ := c.GetPostForm("name")
		email, _ := c.GetPostForm("email")
		password, _ := c.GetPostForm("password")

		stmtIns, err := d.Prepare(`INSERT INTO user(name, email, password) VALUES(?,?,?)`)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		defer stmtIns.Close()

		hash, err := HashPassword(password)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}

		stmtOut, err := stmtIns.Exec(name, email, hash)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}

		num, err := stmtOut.RowsAffected()
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}

		c.JSON(http.StatusCreated, gin.H{
			"num": num,
		})
	}
}
func loginUser(d *sql.DB) func(c *gin.Context) {
	return func(c *gin.Context) {
		email, _ := c.GetPostForm("email")
		password, _ := c.GetPostForm("password")

		stmtOut, err := d.Prepare("SELECT * FROM user WHERE email=?")
		if err != nil {
			panic(err.Error())
		}
		defer stmtOut.Close()

		var user User // we "scan" the result in here
		err = stmtOut.QueryRow(email).Scan(&user)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}

		h, err := HashPassword(password)
		isValidPassword := CheckPasswordHash(h, user.password)

		if isValidPassword {
			c.JSON(http.StatusOK, gin.H{
				"message": "success",
			})
			return
		} else {
			c.JSON(http.StatusBadRequest, gin.H{
				"message": "fail",
			})
		}
	}
}

func findAllBoard(c *gin.Context) {
	c.HTML(http.StatusOK, "index.tmpl", gin.H{
		"title": "Main website",
	})
}

func createBoard(c *gin.Context) {
	c.HTML(http.StatusOK, "index.tmpl", gin.H{
		"title": "Main website",
	})
}
func updateBoard(c *gin.Context) {
	c.HTML(http.StatusOK, "index.tmpl", gin.H{
		"title": "Main website",
	})
}
func deleteBoard(c *gin.Context) {
	c.HTML(http.StatusOK, "index.tmpl", gin.H{
		"title": "Main website",
	})
}

func HashPassword(p string) (string, error) {
	b, err := bcrypt.GenerateFromPassword([]byte(p), 14)
	return string(b), err
}

func CheckPasswordHash(p, h string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(h), []byte(p))
	return err == nil
}
