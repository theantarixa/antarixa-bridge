# 🪐 antarixa-bridge

Agnostic, Zero-Resmon (0.00ms flat) Universal FiveM Bridge designed for high-performance script development across **Qbox (QBX)**, **QBCore**, and **ESX Legacy**, with first-class support for **ox_inventory**, **ox_lib**, and **ox_target**.

<p align="left">
  <img src="https://img.shields.io/badge/LICENSE-MXI.DIGITAL_STUDIOS-00e5ff?style=flat-square&logo=keycdn&logoColor=00e5ff&labelColor=0a0f16" alt="License" />
  <img src="https://img.shields.io/badge/CORP-MXI.DIGITAL_STUDIOS-0a0f16?style=flat-square&logo=shield&logoColor=00e5ff" alt="Corp" />
  <img src="https://img.shields.io/badge/RESMON-0.00ms-00e5ff?style=flat-square&labelColor=0a0f16" alt="Resmon" />
  <img src="https://img.shields.io/badge/FRAMEWORK-QBX_%2F_QB_%2F_ESX-0a0f16?style=flat-square&logo=lua&logoColor=00e5ff" alt="Frameworks" />
</p>

---

## ⚡ Key Features

- **Auto-Detection Engine:** Automatically detects and binds to running frameworks (`qbx_core`, `qb-core`, `es_extended`), inventory systems (`ox_inventory`, `qb-inventory`), and target systems (`ox_target`, `qb-target`).
- **Standardized Player Object:** Calling `Bridge.GetPlayer(source)` always returns a consistent table structure with unified helper functions (`player.addMoney`, `player.addItem`, `player.getJob`, etc.).
- **Zero-Resmon Target Wrapper:** Use identical target zone syntax regardless of whether the server uses `ox_target` or `qb-target`.
- **Automated GitHub Version Checker:** Automatically alerts server console if a new version or bug fix is available on GitHub with patch notes.
- **Dual Usage Support:** Use directly via FiveM `exports` or import effortlessly via `@antarixa-bridge/init.lua`.

---

## 📦 How to Integrate into Your Scripts

### Option 1: Shared Import (Recommended - Cleanest)
In any resource `fxmanifest.lua`, simply add:
```lua
shared_script '@antarixa-bridge/init.lua'
```
Now, `Bridge` is available everywhere in your client and server scripts!

### Option 2: Export Call
```lua
local Bridge = exports['antarixa-bridge']:GetBridge()
```

---

## 📡 Automated GitHub Version Checker

You can register any resource on your server to automatically check for updates and bug fixes on boot:

```lua
-- server-side in your script:
Bridge.RegisterVersionCheck(GetCurrentResourceName(), 'theantarixa/nama-repo-kamu', 'main')
```
If an update is pushed to GitHub, the server console will display:
```
========================================================================
[Antarixa:UPDATE AVAILABLE] NAMA-SCRIPT
Current Version: v1.0.0 ───> Latest Version: v1.0.5
Download / Release: https://github.com/theantarixa/nama-repo-kamu/releases/latest
========================================================================
Patch Notes & Bug Fixes:
  • Fixed oxmysql deadlock on high concurrency
  • Added ox_target model distance culling
------------------------------------------------------------------------
```

---

## 🛠️ API Reference

### 🎮 Server-Side

```lua
-- Get standardized player object
local player = Bridge.GetPlayer(source)
if player then
    print(player.citizenid)
    print(player.job.name, player.job.grade)
    
    -- Money Management
    player.addMoney('cash', 500, 'quest-reward')
    player.removeMoney('bank', 200, 'fee')
    local cash = player.getMoney('cash')
    
    -- Inventory Management
    player.addItem('lockpick', 1)
    player.removeItem('lockpick', 1)
    if player.hasItem('phone') then
        -- do something
    end
end

-- Global Server Functions
Bridge.GetOnlinePlayers()
Bridge.AddItem(source, 'water', 2)
Bridge.RemoveItem(source, 'water', 1)
Bridge.HasItem(source, 'phone', 1)
Bridge.GetItemCount(source, 'bread')
Bridge.CanCarryItem(source, 'gold_bar', 10)
Bridge.SendDiscordLog(webhookUrl, 'Quest Complete', 'Player finished heist', 0x00E5FF)
Bridge.RegisterVersionCheck('my-script', 'theantarixa/my-script')
```

### 💻 Client-Side

```lua
-- Player & Job Status
local pData = Bridge.GetPlayerData()
local job = Bridge.GetJob()      -- { name, label, grade, gradeLabel, isBoss }
local gang = Bridge.GetGang()    -- { name, label, grade, isBoss }
local isDead = Bridge.IsDead()

-- Unified Notifications (ox_lib / QBCore / ESX)
Bridge.Notify('Mission failed!', 'error', 5000, 'HEIST')
Bridge.Notify('Item collected.', 'success', 3000)

-- Unified Progressbar (ox_lib circle/bar or QBCore Progressbar)
Bridge.Progress({
    duration = 4000,
    label = 'Hotwiring vehicle...',
    useCircle = true,
    anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
    disableMovement = true,
    onComplete = function()
        print('Finished!')
    end,
    onCancel = function()
        print('Cancelled.')
    end
})

-- Unified Target (ox_target & qb-target agnostic)
Bridge.AddBoxZone('heist_laptop', vec3(127.0, -1200.0, 29.0), vec3(1.0, 1.0, 1.0), 0.0, {
    {
        name = 'hack_laptop',
        label = 'Hack Database',
        icon = 'fa-solid fa-laptop-code',
        action = function(entity)
            TriggerServerEvent('heist:server:startHack')
        end
    }
})
```

---

## 🔑 License & Ownership

```
Corp Identifier : MXI-DIGITAL-STUDIOS-CORP-SEC-2026
Verified Author : theantarixa (not an astronaut)
Corporation     : MXI.digital Studios (LX-MXI.id co)
```

This software is protected under the **MXI.digital Studios End-User License Agreement (EULA)**.
- Unauthorized redistribution, sub-licensing, or resale is strictly prohibited.
- Modifying or stripping telemetry identifiers or copyright headers constitutes a license violation.

Copyright © 2026 **theantarixa • MXI.digital Studios**. All rights reserved.
