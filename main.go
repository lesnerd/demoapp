package main

import "fmt"

func main() {
	fmt.Println("Hello, 世界")
	calculator := NewIntCalculator(5, 3, add)
	result, err := calculator.calculate()
	if err != nil {
		fmt.Println("Addition should not return an error")
	}
	fmt.Printf("5 + 3 = %d\n", result)
}
