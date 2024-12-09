fs = require("fs");

function parse1(input) {
    const disk = [];
    let file_id = 0;
    for (let i = 0; i < input.length; i++) {
        if (i % 2 == 0) {
            for (let j = 0; j < input[i]; j++) { disk.push(file_id); }
            file_id++;
        } else {
            for (let j = 0; j < input[i]; j++) { disk.push("."); }
        }
    }
    return disk;
}

function parse2(input) {
    const disk = [];
    let file_id = 0;
    for (let i = 0; i < input.length; i++) {
        if (i % 2 == 0) {
            disk.push({ id: file_id++, length: input[i] });
        } else {
            disk.push({ id: ".", length: input[i] });
        }
    }
    return {disk, file_id}
}

function part1(disk) {
    for (let i = disk.length - 1; i >= 0; i--) {
        if (disk[i] == "." || disk.indexOf(".") > i) continue;
        disk[disk.indexOf(".")] = disk[i];
        disk[i] = ".";
    }
    console.log(checksum(disk));
}

function part2({disk, file_id}) {
    for (let i = file_id - 1; i >= 0; i--) {
        let file = disk.findIndex(e => e.id == i),
            free = disk.findIndex(
                e => e.id == "." &&
                e.length >= disk[file].length
            );
        if (!disk[free] || file < free) continue;
        if (disk[free].length > disk[file].length) {
            disk = [
                 ...disk.slice(0, free),
                 { id: disk[file].id, length: disk[file].length },
                 { id: ".", length: disk[free].length - disk[file].length },
                 ...disk.slice(free + 1)
            ];
            disk[file + 1].id = ".";
        } else if (disk[free].length == disk[file].length) {
            disk[free].id = disk[file].id;
            disk[file].id = ".";
        }
    }
    let disk2 = [];
    for (let i = 0; i < disk.length; i++) {
        const {id, length} = disk[i];
        for (let j = 0; j < length; j++) {
            disk2.push(id)
        }
    }
    console.log(checksum(disk2));
}

function checksum(disk) {
    let checksum = 0;
    for (let i = 0; i < disk.length; i++) {
        if (disk[i] != ".") { checksum += disk[i] * i }
    }
    return checksum;
}

const input = fs.readFileSync("input", "utf-8").split("").map(c => +c);
const disk1 = parse1(input);
const disk2 = parse2(input);
part1(disk1);
part2(disk2);