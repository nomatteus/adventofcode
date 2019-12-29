require_relative '../day14'

# Install rspec:
#   gem install rspec
# Run with:
#   rspec day14_spec.rb
RSpec.describe "Day 14" do
  describe Nanofactory do
    let(:input_file) { 'input' }
    let(:subject) { described_class.new(input_file) }

    describe "Part 1" do
      context "my input" do
        it "returns correct answer" do
          expect(subject.ore_required).to eq(504284)
        end
      end

      context "example 1" do
        let(:input_file) { 'examples/input_small1' }

        it "returns correct answer" do
          expect(subject.ore_required).to eq(31)
        end
      end

      context "example 2" do
        let(:input_file) { 'examples/input_small2' }

        it "returns correct answer" do
          expect(subject.ore_required).to eq(165)
        end
      end

      context "example 3" do
        let(:input_file) { 'examples/input_small3' }

        it "returns correct answer" do
          expect(subject.ore_required).to eq(13312)
        end
      end

      context "example 4" do
        let(:input_file) { 'examples/input_small4' }

        it "returns correct answer" do
          expect(subject.ore_required).to eq(180697)
        end
      end

      context "example 5" do
        let(:input_file) { 'examples/input_small5' }

        it "returns correct answer" do
          expect(subject.ore_required).to eq(2210736)
        end
      end
    end
  end
end
