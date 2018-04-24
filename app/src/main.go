package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

var people []Person

func main() {
	fmt.Println("Hello world")
	router := mux.NewRouter()

	people = append(people, Person{ID: "1", Firstname: "John", Lastname: "Doe"})

	router.HandleFunc("/test", GetAll).Methods("GET")

	log.Fatal(http.ListenAndServe(":8000", router))
}

type Person struct {
	ID        string `json:"id,omitempty"`
	Firstname string `json:"firstname,omitempty"`
	Lastname  string `json:"lastname,omitempty"`
}

func GetAll(w http.ResponseWriter, _ *http.Request) {
	json.NewEncoder(w).Encode(people)
}
