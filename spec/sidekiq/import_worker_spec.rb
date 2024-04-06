require "rails_helper"

RSpec.describe ImportWorker, type: :job do
  context "when klass is not a valid importable resource" do
    let(:klass) { "User" }

    it "does not do the import" do
      result = ImportWorker.new.perform(klass, 1)
      expect(result).to eq "[IMPORT] Invalid resource type."
    end
  end

  context "when klass is an issue" do
    let(:klass) { "Issue" }

    context "when the import fails" do
      it "returns the error" do
        issue = instance_double(Issue, persisted?: false)
        expect(Issue).to receive(:import).and_return(issue)
        result = ImportWorker.new.perform(klass, 1)
        expect(result).to eq "[IMPORT] Issue 1 was not imported."
      end
    end

    context "when the import succeeds" do
      it "returns success" do
        issue = instance_double(Issue, persisted?: true)
        expect(Issue).to receive(:import).and_return(issue)
        result = ImportWorker.new.perform(klass, 1)
        expect(result).to eq "[IMPORT] Issue 1 was successfully imported."
      end
    end
  end

  context "when klass is a comic" do
    let(:klass) { "Comic" }

    context "when the import fails" do
      it "does not attempt to import issues" do
        comic = instance_double(Comic, persisted?: false)
        expect(Comic).to receive(:import).and_return(comic)
        expect(comic).not_to receive(:import_issues)
        result = ImportWorker.new.perform(klass, 1)
        expect(result).to eq "[IMPORT] Comic 1 was not imported."
      end
    end

    context "when the import succeeds" do
      it "imports the issues" do
        comic = instance_double(Comic, persisted?: true)
        expect(Comic).to receive(:import).and_return(comic)
        expect(comic).to receive(:import_issues)
        result = ImportWorker.new.perform(klass, 1)
        expect(result).to eq "[IMPORT] Comic 1 was successfully imported with its issues."
      end
    end
  end
end
