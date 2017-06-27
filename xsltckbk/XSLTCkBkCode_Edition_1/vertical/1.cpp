//Forward declarations
class AnsweringMachine;

class AnsweringMachineState
{
public:

    virtual void doCmd(AnsweringMachine& cntx, Command cmd) = 0 ;

} ;


class Connected : public AnsweringMachineState
{
public:

    static Connected& instance() ;

private:

    Connected() {} 
    Connected(const Connected&) {} 
    void operator =(const Connected&) {} 
    void doCmd(AnsweringMachine& cntx, Command cmd);

} ;

class HandlingMsg : public AnsweringMachineState
{
public:

    static HandlingMsg& instance() ;

private:

    HandlingMsg() {} 
    HandlingMsg(const HandlingMsg&) {} 
    void operator =(const HandlingMsg&) {} 
    void doCmd(AnsweringMachine& cntx, Command cmd);

} ;

class Start : public AnsweringMachineState
{
public:

    static Start& instance() ;

private:

    Start() {} 
    Start(const Start&) {} 
    void operator =(const Start&) {} 
    void doCmd(AnsweringMachine& cntx, Command cmd);

} ;

class GoodBye : public AnsweringMachineState
{
public:

    static GoodBye& instance() ;

private:

    GoodBye() {} 
    GoodBye(const GoodBye&) {} 
    void operator =(const GoodBye&) {} 
    void doCmd(AnsweringMachine& cntx, Command cmd);

} ;


class AnsweringMachine
{
public:

    AnsweringMachine::AnsweringMachine();

    void doCmd(Command cmd);
    void changeState(AnsweringMachineState& newSate) ;


    bool moreMsgs();
    void playRemaining();
    void playCurrentMsg();
    void advanceAndPlayMsg();
    void deleteMsg();
    void sayGoodBye();
    void errorMsg();

private:

    AnsweringMachineState* m_State ;

} ;

void Connected::doCmd(AnsweringMachine& cntx, Command cmd)
{
    if (cmd == NEXT_MSG && cntx.moreMsgs())
    {
        cntx.playCurrentMsg() ;
        cntx.changeState(HandlingMsg::instance());
    }
    else
    if (cmd == NEXT_MSG && !cntx.moreMsgs())
    {
        cntx.playRemaining() ;
        cntx.changeState(Connected::instance());
    }
    else
    if (cmd == END)
    {
        cntx.sayGoodBye() ;
        cntx.changeState(GoodBye::instance());
    }
    else
        context.errorMsg() ;
}

void Start::doCmd(AnsweringMachine& cntx, Command cmd)
{
    if (cmd == CONNECT)
    {
        cntx.playRemaining() ;
        cntx.changeState(Connected::instance());
    }
    else
        context.errorMsg() ;
}

void GoodBye::doCmd(AnsweringMachine& cntx, Command cmd)
{
        context.errorMsg() ;
}

void HandlingMsg::doCmd(AnsweringMachine& cntx, Command cmd)
{
    if (cmd == DEL)
    {
        cntx.deleteMsg() ;
        cntx.changeState(Connected::instance());
    }
    else
    if (cmd == NEXT_MSG && cntx.moreMsgs())
    {
        cntx.advanceAndPlayMsg() ;
        cntx.changeState(HandlingMsg::instance());
    }
    else
    if (cmd == NEXT_MSG && !cntx.moreMsgs())
    {
        cntx.playRemaining() ;
        cntx.changeState(Connected::instance());
    }
    else
    if (cmd == END)
    {
        cntx.sayGoodBye() ;
        cntx.changeState(GoodBye::instance());
    }
    else
        context.errorMsg() ;
}

//Constructor
AnsweringMachine::AnsweringMachine()
{
    //Initialize state machine in start state 
    m_State = &Start::instance() ;
}

void AnsweringMachine::changeState(AnsweringMachineState& newState)
{
    m_State = &newState;
}

void AnsweringMachine::doCmd(Command cmd)
{
    m_State->doCmd(*this, cmd);
}

bool AnsweringMachine::moreMsgs()
{
    //!TODO: Implement behavior of this action
}

void AnsweringMachine::playRemaining()
{
    //!TODO: Implement behavior of this action
}

void AnsweringMachine::playCurrentMsg()
{
    //!TODO: Implement behavior of this action
}

void AnsweringMachine::advanceAndPlayMsg()
{
    //!TODO: Implement behavior of this action
}

void AnsweringMachine::deleteMsg()
{
    //!TODO: Implement behavior of this action
}

void AnsweringMachine::sayGoodBye()
{
    //!TODO: Implement behavior of this action
}

void AnsweringMachine::errorMsg()
{
    //!TODO: Implement behavior of this action
}

