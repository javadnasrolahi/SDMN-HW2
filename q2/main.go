package main 

import (
	"fmt"
	"os"
	"os/exec"
	"syscall"
)

func main(){
	switch os.Args[1]{
	case "run":
		run()
	case "child":
		child()
	default:
		panic("help")
	}
}

func run(){
	fmt.Printf("Running %v \n", os.Args[2:])

	cmd := exec.Command("/proc/self/exe", append([]string{"child"}, os.Args[2:]...)...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr 
	cmd.SysProcAttr = &syscall.SysProcAttr {
		Cloneflags:   syscall.CLONE_NEWUTS | syscall.CLONE_NEWPID | syscall.CLONE_NEWNS | syscall.CLONE_NEWNET,
		Unshareflags: syscall.CLONE_NEWNS ,
	}
	must(cmd.Run())
}


func child(){
	fmt.Printf("Running %v %d\n", os.Args[2:], os.Getpid())

	must(syscall.Sethostname([]byte(os.Args[2])))
	must(syscall.Chroot("./ubuntu-fs"))
	must(syscall.Chdir("/"))
	must(syscall.Mount("proc", "proc", "proc", 0, ""))

	cmd := exec.Command("/bin/bash")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	cmd.Run()
	syscall.Unmount("proc", 0)
}


func must(err error){
	if err != nil {
		panic(err)
	}
}