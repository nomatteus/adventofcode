import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Scanner;
import java.util.regex.MatchResult;

/**
 * Created by matt on 2016-12-22.
 */
public class Day08 {
    // Pixel width and height
    public int screenWidth;
    public int screenHeight;

    // Grid of pixels
    int[][] pixels;

    public Day08(int w, int h) {
        screenWidth = w;
        screenHeight = h;
        pixels = new int[w][h];
    }

    public void rect(int width, int height) {
        for (int i=0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                pixels[i][j] = 1;
            }
        }
    }

    public void rotateRow(int rowNum, int amount) {
        int[] newRow = new int[screenWidth];
        for (int i=0; i < screenWidth; i++) {
            int newI = (i + amount) % screenWidth; // new index
            newRow[newI] =  pixels[i][rowNum];
        }
        // Update existing pixels with the new row.
        for (int i=0; i < screenWidth; i++) {
            pixels[i][rowNum] = newRow[i];
        }
    }

    public void rotateColumn(int colNum, int amount) {
        int[] newCol = new int[screenHeight];
        for (int i=0; i < screenHeight; i++) {
            int newI = (i + amount) % screenHeight; // new index
            newCol[newI] =  pixels[colNum][i];
        }
        // Update existing pixels with the new col.
        for (int i=0; i < screenHeight; i++) {
            pixels[colNum][i] = newCol[i];
        }
    }

    public int getNumPixelsOn() {
        int count = 0;
        for (int j=0; j < screenHeight; j++) {
            for (int i = 0; i < screenWidth; i++) {
                if (pixels[i][j] == 1) {
                    count++;
                }
            }
        }
        return count;
    }

    public String toString() {
        StringBuilder screen = new StringBuilder();
        for (int j=0; j < screenHeight; j++) {
            for (int i = 0; i < screenWidth; i++) {
                if (pixels[i][j] == 1) {
                    screen.append("#");
                } else {
                    screen.append(".");
                }
            }
            screen.append("\n");
        }
        return screen.toString();
    }

    // Parse and run a String-based instruction
    public void runInstruction(String input) {
        Scanner scanner = new Scanner(input);
        String command = scanner.next();
        switch (command) {
            case "rect":
                // get dimensions in form (regex):  \d+x\d+
                String dims = scanner.next("(\\d+)x(\\d+)");
                MatchResult result = scanner.match();
                int width = Integer.parseInt(result.group(1));
                int height = Integer.parseInt(result.group(2));
                // Execute command
                this.rect(width, height);
                break;
            case "rotate":
                break;
            default:
                // invalid command
                break;
        }
    }


    public static void main(String[] args) throws Exception {
        Day08 day8 = new Day08(50, 6);
        String[] lines = new String(Files.readAllBytes(Paths.get("src/inputs/day08"))).split("\n");
        for (String line : lines) {
            day8.runInstruction(line);
        }

        System.out.print("--> Part 1: ");
        System.out.println(day8.getNumPixelsOn());
        System.out.println(day8.toString());
        System.out.print("--> Part 2: ");
//        System.out.println(countPart2);
    }
}
