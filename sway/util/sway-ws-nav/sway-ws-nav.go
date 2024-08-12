package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strconv"
)

type Workspace struct {
	Num     int    `json:"num"`
	Name    string `json:"name"`
	Focused bool   `json:"focused"`
}

func main() {
	if len(os.Args) != 2 || (os.Args[1] != "prev" && os.Args[1] != "next") {
		fmt.Println("Usage: ./sway_workspace_helper [prev|next]")
		os.Exit(1)
	}

	direction := os.Args[1]

	// Get current workspaces
	output, err := exec.Command("swaymsg", "-t", "get_workspaces").Output()
	if err != nil {
		fmt.Println("Error executing swaymsg:", err)
		os.Exit(1)
	}

	var workspaces []Workspace
	err = json.Unmarshal(output, &workspaces)
	if err != nil {
		fmt.Println("Error parsing JSON:", err)
		os.Exit(1)
	}

	var currentWorkspace int
	for _, ws := range workspaces {
		if ws.Focused {
			currentWorkspace = ws.Num
			break
		}
	}

	var targetWorkspace int
	if direction == "next" {
		if currentWorkspace == 10 {
			targetWorkspace = 1
		} else {
			targetWorkspace = currentWorkspace + 1
		}
	} else { // prev
		if currentWorkspace == 1 {
			targetWorkspace = 10
		} else {
			targetWorkspace = currentWorkspace - 1
		}
	}

	// Switch to the target workspace
	_, err = exec.Command("swaymsg", "workspace", strconv.Itoa(targetWorkspace)).Output()
	if err != nil {
		fmt.Println("Error switching workspace:", err)
		os.Exit(1)
	}
}
