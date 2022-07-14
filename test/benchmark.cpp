#include <iostream.h>
#include <vector.h>
#include <list.h>
#include <set.h>
#include <function.h>

int main() {
  vector<int> V;
  list<int> L;
  set<int, less<int> > S;
  const int max_count = 1000000;

  cout<<"*** Welcome to the container benchmark (C++) ***"<<endl<<endl;
  
  for(int i=1; i<=max_count; i++)
    L.push_back(i);

  L.erase(L.begin(), L.end());

  for(int i=1; i<=max_count; i++)
    V.push_back(i);

  V.erase(V.begin(), V.end());

  for(int i=1; i<=max_count; i++)
    S.insert(i);

  S.erase(S.begin(), S.end());

  return 1;
}
    
