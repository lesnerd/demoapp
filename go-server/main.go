package main

import (
	"fmt"
	"github.com/hbollon/go-edlib"
	"net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "hello world")
}

func main() {
	res, err := edlib.StringsSimilarity("string1", "string2", edlib.Levenshtein)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Similarity: %f", res)
	}

	http.HandleFunc("/hello", helloHandler)
	http.ListenAndServe(":9001", nil)
}
