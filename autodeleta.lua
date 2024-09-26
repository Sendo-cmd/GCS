local function deleteFolderRecursively(folderPath)
    -- ดึงรายชื่อไฟล์ในโฟลเดอร์
    for _, file in ipairs(listfiles(folderPath)) do
        delfile(file)  -- ลบไฟล์แต่ละไฟล์
    end
    -- ลบโฟลเดอร์เมื่อไฟล์ภายในถูกลบหมดแล้ว
    delfile(folderPath)
end

-- โฟลเดอร์ที่ต้องการลบ
local folderToDelete = "Nousigi Hub/Macro/AnimeVanguards" 

-- ลบโฟลเดอร์และไฟล์ทั้งหมดภายใน
deleteFolderRecursively(folderToDelete)
