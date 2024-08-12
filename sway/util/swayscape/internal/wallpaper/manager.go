package wallpaper

import (
	"math/rand"
	"sort"
	"sync"
)

type WallpaperManager struct {
	wallpapers       []string
	unusedWallpapers []string
	order            string
	mu               sync.RWMutex
}

func NewWallpaperManager(wallpapers []string, order string) *WallpaperManager {
	wm := &WallpaperManager{
		wallpapers: wallpapers,
		order:      order,
	}
	wm.resetUnusedWallpapers()
	return wm
}

func (wm *WallpaperManager) resetUnusedWallpapers() {
	wm.mu.Lock()
	defer wm.mu.Unlock()

	wm.unusedWallpapers = make([]string, len(wm.wallpapers))
	copy(wm.unusedWallpapers, wm.wallpapers)

	switch wm.order {
	case "alphabetical":
		sort.Strings(wm.unusedWallpapers)
	case "random":
		rand.Shuffle(len(wm.unusedWallpapers), func(i, j int) {
			wm.unusedWallpapers[i], wm.unusedWallpapers[j] = wm.unusedWallpapers[j], wm.unusedWallpapers[i]
		})
	}
}

func (wm *WallpaperManager) NextWallpaper() string {
	wm.mu.Lock()
	defer wm.mu.Unlock()

	if len(wm.unusedWallpapers) == 0 {
		wm.resetUnusedWallpapers()
	}

	wallpaper := wm.unusedWallpapers[0]
	wm.unusedWallpapers = wm.unusedWallpapers[1:]

	return wallpaper
}

func (wm *WallpaperManager) AddWallpaper(path string) {
	wm.mu.Lock()
	defer wm.mu.Unlock()

	// Check if the wallpaper already exists
	for _, w := range wm.wallpapers {
		if w == path {
			return
		}
	}

	wm.wallpapers = append(wm.wallpapers, path)
	wm.unusedWallpapers = append(wm.unusedWallpapers, path)

	if wm.order == "alphabetical" {
		sort.Strings(wm.unusedWallpapers)
	}
}

func (wm *WallpaperManager) RemoveWallpaper(path string) {
	wm.mu.Lock()
	defer wm.mu.Unlock()

	for i, w := range wm.wallpapers {
		if w == path {
			wm.wallpapers = append(wm.wallpapers[:i], wm.wallpapers[i+1:]...)
			break
		}
	}

	for i, w := range wm.unusedWallpapers {
		if w == path {
			wm.unusedWallpapers = append(wm.unusedWallpapers[:i], wm.unusedWallpapers[i+1:]...)
			break
		}
	}
}

func init() {
}
