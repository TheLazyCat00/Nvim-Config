#include <cstddef>
#include <functional>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <filesystem>

namespace fs = std::filesystem;
using namespace std;

const int LINES_PER_TEST = 2;

namespace tls {
	struct Range {
		int start;
		int end;
	};

	template<typename T>
	class List : public vector<T> {
	public:
		using vector<T>::vector;

		List<T> range(Range range) const{
			int start = range.start;
			int end = range.end;
			if (end < 0){
				end = this -> size() + end;
			}
			return List<T>(
				this -> begin() + start,
				this -> begin() + end + 1
			);
		}
	};

	class Buffer : public List<string> {
	public:
		using List<string>::List;

		Buffer range(Range range) {
			List<string> result = List<string>::range(range);
			return Buffer(result.begin(), result.end());
		}

		string concatenate() const{
			string result;
			for (const auto & str : * this) {
				result += str;
			}
			return result;
		}
	};

	template<typename T>
	void print(T value){
		std::cout << value;
		cout << "\n";
	}

	template<>
	void print(bool value){
		std::cout << (value ? "true" : "false");
		cout << "\n";
	}

	template<>
	void print(Buffer value) {
		for (const auto& str : value) {
			std::cout << str;
			cout << "\n";
		}
	}

	template<>
	void print(Range value) {
		cout << "start: " << value.start << ", end: " << value.end;
		cout << "\n";
	}

	string read(string filepath){
		ifstream file(filepath);
		if (!file) {
			cerr << "Error: could not open file '" << filepath << "'\n";
		}

		stringstream buffer;
		buffer << file.rdbuf();
		return buffer.str();
	};

	void write(string filepath, string text){
		std::ofstream outFile(filepath);
		if (outFile.is_open()) {
			outFile << text;
			outFile.close();
		}
	}

	Buffer getLines(string raw){
		Buffer buffer({});

		stringstream ss(raw);
		string line;
		while (getline(ss, line)) {
			buffer.push_back(line);
		}

		return buffer;
	}

	string getOutFile(){
		fs::path thisPath(__FILE__);
		string outFile = thisPath.replace_extension("").string() + "_output.txt";
		return outFile;
	}
};

class TestData {
public:
	string filepath;
	string raw;
	tls::Buffer content;
	tls::Buffer body;
	tls::List<tls::Buffer> tests;
	size_t nTests;

	TestData(string filepath) : filepath(filepath){
		raw = tls::read(filepath);
		content = tls::getLines(raw);
		body = content.range({ 1, -1 });
		nTests = stoi(getLine(0));

		for(size_t testNumber = 0; testNumber < nTests; testNumber ++){
			tls::Range window;
			window.start = testNumber * LINES_PER_TEST;
			window.end = window.start + LINES_PER_TEST - 1;

			tls::Buffer data = body.range(window);
			tests.push_back(data);
		}
	}

	string getLine(size_t lineNumber) const {
		if (content.size() < lineNumber) {
			return "";
		}

		return content[lineNumber];
	}

	void registerSolution(function<tls::Buffer(tls::Buffer)> algorithm) const{
		tls::Buffer solution{};
		for (const auto & test : tests){
			tls::Buffer testResult = algorithm(test);

			solution.insert(solution.end(), testResult.begin(), testResult.end());
			tls::print(testResult);
		}

		string outFile = tls::getOutFile();
		tls::write(outFile, solution.concatenate());
	}
};

class Program{
public:
	TestData testData;
	Program(string filepath) : testData(filepath) {
		testData.registerSolution(algorithm);
	}
	
	static tls::Buffer algorithm(tls::Buffer data){
		return data;
	}
};

int main(int argc, char* argv[]) {
	if (argc < 2) { // check if a file path was provided
		cerr << "Usage: " << argv[0] << " <path_to_file>\n";
		return 1;
	}

	string filepath = argv[1]; // get the file path from command line
	Program program(filepath);

	return 0;
}
