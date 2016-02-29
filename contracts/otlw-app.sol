contract Master
{
  //Initialize master data store
  mapping (address => uint) tokenBalance;
  mapping (address => string) tagName;
  mapping (string => address) tagAddressFromName;
  mapping (address => address[]) acheivements;

  function Master()
  {

  }

  function mapTokenBalance(address a, uint b)
  {
    tokenBalance[a] = b;
  }
  function mapTagName(address a, string n)
  {
    tagName[a] = n;
  }
  function mapTagAddressFromName(string n, address a)
  {
    tagAddressFromName[n] = a;
  }
  function mapAcheivement(address a, address t)
  {
    acheivements[a].push(t);
  }
  function getTokenBalance(address a) returns(uint)
  {
    return tokenBalance[a];
  }
  function getTagName(address a) returns(string)
  {
    return tagName[a];
  }
  function getTagAddressFromName(string n) returns(address)
  {
    return tagAddressFromName[n];
  }
  function getAcheivement(address a) returns(address[])
  {
    return acheivements[a];
  }
  function getNumberOfAcheivements(address a) returns(uint)
  {
    return acheivements[a].length;
  }

  function addTag(string name, address[] parentList) returns(uint) //Creates a new tag contract
  {
    uint response = 0;
    if(tokenBalance[msg.sender] < 1)
    {
      response += 1;
    }
    if(tagAddressFromName[name] == 0)
    {
      response += 10;
    }
    if(response==0)
    {
      Tag newTag = new Tag();
      address newTagAddress = address(newTag);
      tagName[newTagAddress] = name;
      tagAddressFromName[name] = newTagAddress;

      for(uint i=0; i<= parentList.length; i++) //adds all the given parents
      {
        if(parentList[i]==0)
        {
          response += 100;
        }
        if(response==0)
        {
          newTag.addParent(parentList[i]);
        }
      }
    }
    newTag.setMaster(address(this));
    newTag.setName(name);
    return response;
  }
}

//Defines the meta-contract for a Tag
contract Tag
{
  address[] parentTags;
  address master;
  string name;
  address[] owners; //Those who have earned the tag
  mapping(address => address[]) assessmentHistory; //All assessments completed
  mapping(address => uint) scores; //All positive assessements scores

  function Tag()
  {

  }

  function addParent(address parentTag)
  {
    parentTags.push(parentTag);
  }

  function setMaster(address m)
  {
    master = m;
  }

  function setName(string n)
  {
    name = n;
  }

  function getAssessors(uint randomNumber) returns(address[])
  {

  }

  function startAssessment(address assessee, address[] assessors)
  {
    Assessment newAssessment;
    newAssessment.setAssessee(assessee);
    newAssessment.setAssessors(assessors);
    newAssessment.setTag(address(this));
  }

  function finishAssessment(bool result, uint score, address assessee, address assessment) returns(bool)
  {
    if(result == true)
    {
      owners.push(assessee);
      scores[assessee] = score;
      Master(master).mapAcheivement(assessee,address(this));
    }
    assessmentHistory[assessee].push(assessment);
    return result;
  }
}

//Defines the meta-contract for an assessment
contract Assessment
{
  address assessee; //We need a better word for this
  address[] assessors;
  address tag;
  struct Results
  {
    bool pass;
    uint score;
  }
  mapping(address => uint[]) assessmentQuestions; //Given by the assessors as IPFS hashes
  mapping(address => uint[]) assessmentAnswers; //Given by the assessee as IPFS hashes
  mapping(address => Results) assessmentResults; //Pass/Fail and Score given by assessors
  uint finalScore;
  bool finalResult;

  function Assessment()
  {

  }

  function setAssessee(address newAssessee)
  {
    assessee = newAssessee;
  }

  function setAssessors(address[] newAssessors)
  {
    assessors = newAssessors;
  }

  function setTag(address t)
  {
    tag = t;
  }

  function setQuestion(address a, uint[] data)
  {
    assessmentQuestions[a] = data;
  }

  function getQuestion(address a) returns(uint[])
  {
    return assessmentQuestions[a];
  }

  function setAnswer(address a, uint[] data)
  {
    assessmentAnswers[a] = data;
  }

  function getAnswer(address a) returns(uint[])
  {
    return assessmentAnswers[a];
  }

  function setResult(address a, bool b, uint s)
  {
    Results memory results;
    results.pass = b;
    results.score = s;
    assessmentResults[a] = results;
  }

  function assess()
  {

  }

  function calculateResult()
  {

  }

  function returnResults()
  {
    Tag(tag).finishAssessment(finalResult, finalScore, assessee, address(this));
  }

  function cashout()
  {

  }
}