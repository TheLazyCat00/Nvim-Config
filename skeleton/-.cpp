#include <cstddef>
#include <cstdlib>
#include <functional>
#include <iostream>
#include <fstream>
#include <regex>
#include <stacktrace>
#include <stdexcept>
#include <string>
#include <sstream>
#include <vector>
#include <filesystem>

namespace fs = std::filesystem;
using namespace std;

const int LINES_PER_TEST = 2;

namespace tls {
	void printStacktrace(const stacktrace & trace){
		cout << "Stacktrace:\n";
		for(const auto & frame : trace){
			cout << frame << "\n";
		}
	}

	template<typename ExceptionType>
	void error(const string & msg) {
		cerr << msg << "\n";
		stacktrace trace = stacktrace::current();
		printStacktrace(trace);
		throw ExceptionType(msg);
	}

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

		void sort(function<float(const T &)>getValue){
			std::sort(this -> begin(), this -> end(), [ & getValue](const T & a, const T & b) {
				return getValue(a) < getValue(b);
			});
		}

		bool contains(T element) const{
			return find(this -> begin(), this -> end(), element) != this -> end();
		}

		template<typename GenericOut>
		List<GenericOut> apply(const function<GenericOut(T)> callback){
			List<GenericOut> result;
			for (const T& element : *this) {
				result.push_back(callback(element));
			}

			return result;
		}

		size_t index(const T & item) const{
			for(size_t index = 0; index < this -> size(); index ++ ){
				if (( * this)[index] == item){
					return index;
				}
			}

			error<out_of_range>("Element not found in List");
		}

		void remove(const T & item){
			size_t index = this -> index(item);
			this -> erase(this -> begin() + index);
		}
	};

	class Buffer : public List<string> {
	public:
		using List<string>::List;

		Buffer(const List<string> & list) : List<string>(list) {}

		string concatenate() const{
			string result = this -> concatenate("\n");
			return result;
		}

		string concatenate(string delimiter) const{
			if(this->size() == 0){
				return "";
			}

			string result;
			for (size_t i = 0; i < this -> size() - 1; i ++ ) {
				string str = (* this)[i];
				result += str;
				result += delimiter;
			}

			result += (* this)[this -> size() - 1];
			return result;
		}
	};

	template<typename T>
	struct Element {
		T value;
		size_t index;
		tls::List<T> & list;
		Element<T>(tls::List<T> & list, size_t index):
			value(list[index]), index(index), list(const_cast<tls::List<T>&>(list)) {}
	};

	template<typename T>
	void print(T value){
		std::cout << value;
		cout << "\n";
	}

	void print(bool value){
		std::cout << (value ? "true" : "false");
		cout << "\n";
	}

	void print(const Buffer & value) {
		for (const auto& str : value) {
			print(str);
		}
	}

	void print(const string & value) {
		cout << value;
		cout << "\n";
	}

	void print(Range value) {
		cout << "start: " << value.start << ", end: " << value.end;
		cout << "\n";
	}

	template<typename T>
	void print(const List<T>& value) {
		for (const auto& element : value) {
			print(element);
		}
	}

	string read(const string& filepath){
		ifstream file(filepath);
		if (!file) {
			cerr << "Error: could not open file '" << filepath << "'\n";
		}

		stringstream buffer;
		buffer << file.rdbuf();
		return buffer.str();
	};

	void write(const string & filepath, const string & text){
		std::ofstream outFile(filepath);
		if (outFile.is_open()) {
			outFile << text;
			outFile.close();
		}
	}

	Buffer getLines(const string & raw){
		Buffer buffer{};

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

	List<string> split(const string & str, const string & delimiter){
		List<string> tokens;
		regex re(delimiter);
		sregex_token_iterator it(str.begin(), str.end(), re, -1);
		sregex_token_iterator reg_end;

		for (; it != reg_end; ++it) {
			tokens.push_back(it->str());
		}

		return tokens;
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

	TestData(const string& filepath) : filepath(filepath){
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

	void registerSolution(function<tls::Buffer(tls::Buffer, int)> algorithm) const{
		tls::Buffer solution{};
		for (size_t i = 0; i < tests.size(); i ++ ){
			tls::Buffer test = tests[i];
			tls::Buffer testResult = algorithm(test, i);

			solution.insert(solution.end(), testResult.begin(), testResult.end());
			tls::print(testResult);
		}

		string outFile = tls::getOutFile();
		tls::write(outFile, solution.concatenate());
	}
};

class Program{
public:
	Program() {
	}

	tls::Buffer algorithm(tls::Buffer data, int testNumber) {
		
	}
};

tls::Buffer testCase(tls::Buffer data, int testNumber){
	Program program{};
	return program.algorithm(data, testNumber);
}

int main(int argc, char * argv[]) {
	if (argc < 2) { // check if a file path was provided
		cerr << "Usage: " << argv[0] << " <path_to_file>\n";
		return 1;
	}

	string filepath = argv[1]; // get the file path from command line
	
	TestData testData(filepath);
	testData.registerSolution(testCase);

	return 0;
}
