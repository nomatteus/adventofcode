import java.nio.file.Paths;
import java.util.Scanner;

/**
 * Created by matt on 2016-12-21.
 */
public class Day03 {

    public static boolean isValidTriangle(int side1, int side2, int side3) {
        return (side1 + side2) > side3 && (side1 + side3) > side2 && (side2 + side3) > side1;
    }

    public static void main(String[] args) throws Exception {
        Scanner scanner = new Scanner(Paths.get("src/inputs/day03"));
        int numCorrectTriangles = 0;
        while (scanner.hasNextLine()) {
            int side1 = scanner.nextInt();
            int side2 = scanner.nextInt();
            int side3 = scanner.nextInt();
            if (isValidTriangle(side1, side2, side3)) {
                numCorrectTriangles++;
            }
        }
        System.out.println("--> Part 1: " + numCorrectTriangles);

        // PART 2
        scanner = new Scanner(Paths.get("src/inputs/day03"));
        numCorrectTriangles = 0; // reset
        while (scanner.hasNextLine()) {
            // Grab sides in batches of 2
            int[] side1 = {scanner.nextInt(), scanner.nextInt(), scanner.nextInt()};
            int[] side2 = {scanner.nextInt(), scanner.nextInt(), scanner.nextInt()};
            int[] side3 = {scanner.nextInt(), scanner.nextInt(), scanner.nextInt()};
            for (int i=0; i < 3; i++) {
                if (isValidTriangle(side1[i], side2[i], side3[i])) {
                    numCorrectTriangles++;
                }
            }
        }
        System.out.println("--> Part 2: " + numCorrectTriangles);
    }
}
