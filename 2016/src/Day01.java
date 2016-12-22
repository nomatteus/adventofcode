import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashSet;

/**
 * Created by matt on 2016-12-21.
 */
public class Day01 {

    // Represents north/south/east/west.
    // We don't really care about the actual direction, since the answer
    // will be
    int[] directions = {0, 1, 2, 3};

    enum TurnDirection {
        Left, Right
    }

    // Given you are facing a direction and about to turn, determine what your new
    // direction will be after executing turn.
    public static int nextDirection(Integer dir, TurnDirection turnDir) {
        BigInteger dirBig = new BigInteger(dir.toString());
        BigInteger newDir;
        if (turnDir == TurnDirection.Left) {
            newDir = dirBig.subtract(BigInteger.ONE).mod(new BigInteger("4"));
        } else { // Right
            newDir = dirBig.add(BigInteger.ONE).mod(new BigInteger("4"));
        }
        return newDir.intValue();
    }

    public static TurnDirection parseTurnDir(String input) {
        char dirChar = input.charAt(0);
        TurnDirection turnDir;
        switch (dirChar) {
            case 'R':
                turnDir = TurnDirection.Right;
                break;
            case 'L':
                turnDir = TurnDirection.Left;
                break;
            default:
                turnDir = null;
                // Error...
        }
        return turnDir;
    }

    public static int parseNumBlocks(String input) {
        return Integer.parseInt(input.substring(1));
    }

    class Move {
        public TurnDirection turnDir;
        public int numBlocks;

        public Move(TurnDirection dir, int numBlocks) {
            this.turnDir = dir;
            this.numBlocks = numBlocks;
        }

        // Allows creating move with string in format (regex): "(R|L)\d+"
        public Move(String move) {
            this(parseTurnDir(move), parseNumBlocks(move));
        }

    }

    class Location extends ArrayList<Integer> {
        public Location(int x, int y) {
            super();
            // 2 element list
            this.add(0, x);
            this.add(1, y);
        }

        @Override
        public String toString() {
            return String.format("(%s,%s)", get(0), get(1));
        }
    }

    public int calculate(String input) {
        String[] moves = input.split(", ");
        // Track Position using x,y axis: Start at (0, 0)
        int currentX = 0;
        int currentY = 0;

        // Start at a direction, doesn't matter which
        int currentDir = 0;

        // Execute turn
        for (String moveStr : moves) {
            Move move = new Move(moveStr);
            // Execute turning in given direction
            currentDir = nextDirection(currentDir, move.turnDir);

            // Update current x and y given the direction we are facing
            switch (currentDir) {
                case 0: // N
                    currentX += move.numBlocks;
                    break;
                case 1: // E
                    currentY += move.numBlocks;
                    break;
                case 2: // S
                    currentX -= move.numBlocks;
                    break;
                case 3: // W
                    currentY -= move.numBlocks;
                    break;
            }
        }

        return Math.abs(currentX) + Math.abs(currentY);
    }

    // Part 2
    public int distanceToFirstLocationVisitedTwice(String input) {
        String[] moves = input.split(", ");
        // Track Position using x,y axis: Start at (0, 0)
        int currentX = 0;
        int currentY = 0;

        // Start at a direction, doesn't matter which
        int currentDir = 0;

        /*
        * Approach: Use a HashSet to store each location visited.
        * We check for existence of a location first, and if it exists,
        * then return the distance to that location.
        */
        HashSet<Location> locationSet = new HashSet<Location>();
        // Add our initial location as visited
        locationSet.add(new Location(currentX, currentY));

        // Execute turn
        for (String moveStr : moves) {
            Move move = new Move(moveStr);
            // Execute turning in given direction
            currentDir = nextDirection(currentDir, move.turnDir);

            // Move one block at a time so we can check each location
            for (int i = 0; i < move.numBlocks; i++) {
                // Update current x and y given the direction we are facing
                switch (currentDir) {
                    case 0: // N
                        currentX++;
                        break;
                    case 1: // E
                        currentY++;
                        break;
                    case 2: // S
                        currentX--;
                        break;
                    case 3: // W
                        currentY--;
                        break;
                }

                // Now we have our new location at (currentX, currentY), so
                // check if we have been there before, or log visit if not.
                Location loc = new Location(currentX, currentY);
                boolean added = locationSet.add(loc);
                if (!added) {
                    // If not added, then it exists already, so return
                    // distance to current point.
                    return Math.abs(currentX) + Math.abs(currentY);
                }
            }
        }
        return -1; // no location visited twice
    }

    public static void main(String[] args) throws IOException {
        Day01 day01 = new Day01();
        String input = new String(Files.readAllBytes(Paths.get("src/inputs/day01")));

        System.out.println("---> Part 1");
        System.out.println("QUESTION: How many blocks away is Easter Bunny HQ?");
        System.out.print("ANSWER: ");
        System.out.println(day01.calculate(input));
        System.out.println("----------");

        // Part 2
        System.out.println("---> Part 2");
        System.out.println("QUESTION: How many blocks away is Easter Bunny HQ?");
        System.out.print("ANSWER: ");
        System.out.println(day01.distanceToFirstLocationVisitedTwice(input));
    }
}
