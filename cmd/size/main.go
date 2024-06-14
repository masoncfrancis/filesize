package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
)

func main() {
	// Define the -l flag
	listFlag := flag.Bool("l", false, "list sizes of files within the first level of the directory")
	flag.Parse()

	if flag.NArg() < 1 {
		fmt.Println("Usage: go run main.go [-l] <file_or_directory>")
		return
	}

	path := flag.Arg(0)
	fileInfo, err := os.Stat(path)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	if fileInfo.IsDir() {
		if *listFlag {
			listDirSizes(path)
		} else {
			dirSize, err := getDirSize(path)
			if err != nil {
				fmt.Println("Error:", err)
				return
			}
			fmt.Printf("The size of the directory %s is %s\n", path, formatSize(dirSize))
		}
	} else {
		fmt.Printf("The size of the file %s is %s\n", path, formatSize(fileInfo.Size()))
	}
}

func getDirSize(path string) (int64, error) {
	var size int64
	err := filepath.Walk(path, func(_ string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			size += info.Size()
		}
		return nil
	})
	return size, err
}

func listDirSizes(path string) {
	file, err := os.Open(path)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	defer file.Close()

	files, err := file.Readdir(0)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	totalSize := int64(0)
	for _, fileInfo := range files {
		size := fileInfo.Size()
		if fileInfo.IsDir() {
			dirPath := filepath.Join(path, fileInfo.Name())
			size, err = getDirSize(dirPath)
			if err != nil {
				fmt.Println("Error:", err)
				return
			}
		}
		totalSize += size
		fmt.Printf("%s: %s\n", filepath.Join(path, fileInfo.Name()), formatSize(size))
	}
	fmt.Printf("The total size of the directory %s is %s\n", path, formatSize(totalSize))
}

func formatSize(size int64) string {
	const (
		KB = 1 << (10 * iota)
		MB
		GB
		TB
	)

	switch {
	case size >= TB:
		return fmt.Sprintf("%.2f TB", float64(size)/TB)
	case size >= GB:
		return fmt.Sprintf("%.2f GB", float64(size)/GB)
	case size >= MB:
		return fmt.Sprintf("%.2f MB", float64(size)/MB)
	case size >= KB:
		return fmt.Sprintf("%.2f KB", float64(size)/KB)
	default:
		return fmt.Sprintf("%d bytes", size)
	}
}
