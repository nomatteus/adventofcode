import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by matt on 2016-12-21.
 */
public class Day04 {

    public static class Room {
        private String nameLetters;
        private String name;
        private String decryptedName = null;
        private Integer sectorId;
        private String checksum = null; // actual checksum
        private String checksumInput; // input (claimed) checksum

        public Room(String input) {
            Pattern pattern = Pattern.compile("([a-z-]+)(\\d+)\\[([a-z]+)\\]");
            Matcher matcher = pattern.matcher(input);
            matcher.matches();
            name = matcher.group(1);
            nameLetters = name.replace("-", "");
            sectorId = Integer.parseInt(matcher.group(2));
            checksumInput = matcher.group(3);
        }

        public boolean isRealRoom() {
            // Real room if claimed (input) checksum equals calculated checksum
            return checksumInput.equals(getChecksum());
        }

        public String decryptRoomName() {
            if (decryptedName == null) {
                StringBuilder decryptedNameBuilder = new StringBuilder();
                for (Character c : name.toCharArray()) {
                    Integer charNum = (int) c;
                    if (c == '-') {
                        decryptedNameBuilder.append(' ');
                    } else {
                        // Letter position from 0 to 26, since 97 ascii = 'a'
                        Integer letterPos = charNum-97;

                        BigInteger newChar = (new BigInteger(sectorId.toString()))
                                .add(new BigInteger(letterPos.toString()))
                                .mod(new BigInteger("26"));
                        // add 97 to bring it back to ascii code
                        decryptedNameBuilder.append((char) (newChar.intValue() + 97));
                    }
                }
                decryptedName = decryptedNameBuilder.toString();
            }
            return decryptedName;
        }

        public String getChecksum() {
            if (checksum == null) {
                // calculate checksum
                // Use a HashMap to hold the character->frequency mappings
                HashMap<Character, Integer> charCountMap = new HashMap<>();
                for (int i = 0; i < nameLetters.length(); i++) {
                    char c = nameLetters.charAt(i);
                    if (charCountMap.containsKey(c)) {
                        // Increment current value
                        charCountMap.put(c, charCountMap.get(c) + 1);
                    } else {
                        // Put initial value in hashmap
                        charCountMap.put(c, 1);
                    }
                }

                // Sort with the highest frequencies first, breaking ties by using
                // natural character order
                ArrayList<Map.Entry<Character, Integer>> freqList = new ArrayList<>(charCountMap.entrySet());
                Collections.sort(freqList, new Comparator<Map.Entry<Character, Integer>>() {
                    @Override
                    public int compare(Map.Entry<Character, Integer> o1, Map.Entry<Character, Integer> o2) {
                        // Compare frequencies.. we want reverse order (highest first)
                        int compareFreq = o2.getValue().compareTo(o1.getValue());
                        if (compareFreq != 0) {
                            return compareFreq;
                        }
                        // If frequencies are equal, then compare on character
                        return o1.getKey().compareTo(o2.getKey());
                    }
                });

                // Now we just take the first 5 items from the frequency list, and that is the checksum!
                StringBuilder checksumBuilder = new StringBuilder();
                for (int i = 0; i < 5; i++) {
                    checksumBuilder.append(freqList.get(i).getKey());
                }

                checksum = checksumBuilder.toString();
            }
            return checksum;
        }

        @Override
        public String toString() {
            return String.format("name: %s, sectorId: %d, actualChecksum: %s (claimed checksum: %s)",
                    name, sectorId, getChecksum(), checksumInput);
        }
    }

    public int sumSectorIdsOfRealRooms(String input) {
        String[] rooms = input.split("\n");
        int sum = 0;
        for (String roomStr : rooms) {
            Room room = new Room(roomStr);
            if (room.isRealRoom()) {
                sum += room.sectorId;
            }
        }
        return sum;
    }

    public int decryptToFindNorthPoleSectorId(String input) {
        String[] rooms = input.split("\n");
        for (String roomStr : rooms) {
            Room room = new Room(roomStr);
            if (room.isRealRoom()) {
                if (room.decryptRoomName().matches("northpole.*")) {
                    return room.sectorId;
                }
            }
        }
        return -1; // not found
    }

    public static void main(String[] args) throws IOException {
        Day04 day4 = new Day04();
        String input = new String(Files.readAllBytes(Paths.get("src/inputs/day04")));
        System.out.print("--> Part 1: ");
        System.out.println(day4.sumSectorIdsOfRealRooms(input));
        System.out.print("--> Part 2: ");
        System.out.println(day4.decryptToFindNorthPoleSectorId(input));
    }
}
