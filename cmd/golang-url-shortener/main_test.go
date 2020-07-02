package main

import (
	"io/ioutil"
	"net"
	"testing"
	"time"

	"github.com/russelltsherman/golang-url-shortener/internal/util"
)

func TestInitShortener(t *testing.T) {
	tmpdir, err := ioutil.TempDir("", "shorten")
	if err != nil {
		t.Fatal(err)
	}
	util.Config.DataDir = tmpdir
	if err = initConfig(); err != nil {
		t.Fatal(err)
	}
	close, err := initShortener()
	if err != nil {
		t.Fatalf("could not init shortener: %v", err)
	}
	time.Sleep(time.Millisecond * 200) // Give the http server a second to boot up
	// We expect there a port is in use error
	if _, err := net.Listen("tcp", util.GetConfig().ListenAddr); err == nil {
		t.Fatalf("port is not in use: %v", err)
	}
	close()
}
