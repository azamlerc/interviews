import React from 'react';
import ReactDOM from 'react-dom';

// calculate a ^ b and b ^ a if a and b are both in this set
const powers = [2, 3, 4, 9, 24];

// calcualte √n if n is in this set
const squares = [4, 9, 16, 25, 36, 49, 64, 81,
  100, 4096, 16777216, 281474976710656];

const labelNames = {
  digit: "Four (4)",
  decimalPoint: "Decimal Point (.4)",
  multiDigit: "Multi-Digit (44)",
  repeating: "Repeating (4…)",
  addition: "Addition (+)",
  subtraction: "Subtraction (–)",
  multiplication: "Multiplication (x)",
  division: "Division (÷)",
  squareRoot: "Square Root (√4)",
  factorial: "Factorial (4!)",
  power: "Power (^)",
  rounding: "Rounding",
};

class FourFours extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      number: 4,
      count: 4,
      max: 100,
      digit: true,
      squareRoot: true,
      factorial: true,
      decimalPoint: true,
      multiDigit: false,
      addition: true,
      subtraction: true,
      multiplication: true,
      division: true,
      power: false,
      rounding: true,
      repeating: false,
    };

    this.updateOptions = this.updateOptions.bind(this);
  }
  
  updateOptions(newState) {
    this.setState(newState);
  }

  fourFours() {
    const n = parseInt(this.state.number);
    const c = parseInt(this.state.count);
    
    const fours = [];
    for (let i = 0; i <= c; i++) fours.push({});
    if (c < 1 || n < 1) return fours;

    if (this.state.digit) 
      fours[1][n] = `${n}`;
    if (this.state.squareRoot && squares.includes(n)) 
      fours[1][`${Math.sqrt(n)}`] = `√${n}`;
    if (this.state.factorial && n > 2) 
      fours[1][factorial(n)] = `${n}!`;
    if (this.state.decimalPoint) 
      fours[1][n/10] = `.${n}`;
    if (this.state.multiDigit && c > 1) {
      fours[2][n*11] = `${n}${n}`;
      if (this.state.decimalPoint) {
        fours[2][n*1.1] = `${n}.${n}`;
        fours[2][n*.11] = `.${n}${n}`;
      }
    }
    if (this.state.repeating) {
      fours[1][n/9] = `.${n}…`;
    }

    for (let i = 2; i <= c; i++) {
      for (let a = 1; a <= i / 2; a++) {
        let b = i - a;
        this.combine(fours, a, b);
      }
    }
    
    return fours;
  }

  combine(fours, countA, countB) {
    const index = countA + countB;
    const newSet = fours[index];
    const parens = index != this.state.count;
    for (let keyA in fours[countA]) {
      const a = parseFloat(keyA);
      const strA = fours[countA][keyA];
      for (let keyB in fours[countB]) {
        const b = parseFloat(keyB);
        const strB = fours[countB][keyB];

        if (this.state.division) {
          if (a != 0)
              this.addToSet(newSet, b / a, parens, `${strB} ÷ ${strA}`);
          if (b != 0)
              this.addToSet(newSet, a / b, parens, `${strA} ÷ ${strB}`);
        }
        
        if (this.state.subtraction) {
          this.addToSet(newSet, b - a, parens, `${strB} – ${strA}`);
          this.addToSet(newSet, a - b, parens, `${strA} – ${strB}`);
        }
        
        if (this.state.multiplication)   
          this.addToSet(newSet, a * b, parens, `${strA} x ${strB}`);
        
        if (this.state.addition) 
          this.addToSet(newSet, a + b, parens, `${strA} + ${strB}`);
        
        // perform exponentiation if both a and b are small integers
        if (this.state.power && powers.includes(a) && powers.includes(b)) {
          this.addToSet(newSet, Math.pow(a, b), parens, `${strA} ^ ${strB}`);
          this.addToSet(newSet, Math.pow(b, a), parens, `${strB} ^ ${strA}`);
        }
      }
    }
  }

  addToSet(newSet, value, parens, description) {
      if (parens)
          description = `(${description})`;
      if (this.state.rounding)
        value = round(value, 6);
      if (!newSet[value] || description.length <= newSet[value].length) 
          newSet[value] = description;
    
      // if the value is a square, also take the square root
      if (this.state.squareRoot && squares.includes(value)) {
        this.addToSet(newSet, Math.sqrt(value), false, `√${description}`);
      } 
  }

  render() {
    const fours = this.fourFours();
    const last = this.state.count > 0 ? fours[this.state.count] : [];
    return (
      <div>
        <OptionsList options={this.state} optionsChanged={this.updateOptions} />
        <br />
        <Score max={this.state.max} fours={last}/>
        <br />
        <NumberList max={this.state.max} fours={last}/>
      </div>
    );
  }
}

class OptionsList extends React.Component {
  constructor(props) {
    super(props);
    this.state = props.options;
  
    this.toggleCheckbox = this.toggleCheckbox.bind(this);
    this.numberChanged = this.numberChanged.bind(this);
    this.countChanged = this.countChanged.bind(this);
    this.maxChanged = this.maxChanged.bind(this);
  }

  toggleCheckbox(label) {
    let newState = [];
    newState[label] = !this.state[label];
    this.setState(newState);
    this.props.optionsChanged(newState);
  }

  numberChanged(event) {
    let number = event.target.value;
    if (number < 0) number = 1;
    if (number > 9) number = 9;
    const newState = {number};
    this.setState(newState);
    this.props.optionsChanged(newState);
  }
  
  countChanged(event) {
    let count = event.target.value;
    if (count < 0) count = 1;
    if (count > 6) count = 6;
    const newState = {count};
    this.setState(newState);
    this.props.optionsChanged(newState);
  }
  
  maxChanged(event) {
    let max = event.target.value;
    if (max < 1) max = 1;
    if (max > 1000) max = 1000;
    const newState = {max};
    this.setState(newState);
    this.props.optionsChanged(newState);
  }
  
  makeCheckbox(label) {
    return (
      <Checkbox label={label} 
        checked={this.state[label]}
        handleCheckboxChange={this.toggleCheckbox}
        key={label} />
    );
  }

  makeCheckboxColumn(labels) {
    return (<td width="25%">
        { labels.map(label => this.makeCheckbox(label)) }
      </td>)
  }

  render() {
    return (
      <form>
        <table width="100%">
          <tbody>
            <tr>
              { this.makeCheckboxColumn([
                "digit", "squareRoot", "factorial", "decimalPoint"]) }
              { this.makeCheckboxColumn([
                "addition", "subtraction", "multiplication", "division"]) }
              { this.makeCheckboxColumn([
                "multiDigit", "repeating", "power", "rounding"]) }
              <td width="25%" valign="top">
                Number: <select value={this.state.number} onChange={this.numberChanged}>
                  <option value="1">one</option>
                  <option value="2">two</option>
                  <option value="3">three</option>
                  <option value="4">four</option>
                  <option value="5">five</option>
                  <option value="6">six</option>
                  <option value="7">seven</option>
                  <option value="8">eight</option>
                  <option value="9">nine</option>
                </select><br />
                Count: <select value={this.state.count} onChange={this.countChanged}>
                  <option value="1">one</option>
                  <option value="2">two</option>
                  <option value="3">three</option>
                  <option value="4">four</option>
                  <option value="5">five</option>
                  <option value="6">six</option>
                </select><br />
                Maximum: <select value={this.state.max} onChange={this.maxChanged}>
                  <option value="100">100</option>
                  <option value="200">200</option>
                  <option value="300">300</option>
                  <option value="400">400</option>
                  <option value="500">500</option>
                </select><br />
              </td>
            </tr>
          </tbody>
        </table>
      </form>
    );
  }
}
  
class Checkbox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isChecked: this.props.checked,
    }

    this.toggleCheckboxChange = this.toggleCheckboxChange.bind(this);
  }
  
  toggleCheckboxChange() {
    this.setState(({ isChecked }) => ({
        isChecked: !isChecked,
    }));

    this.props.handleCheckboxChange(this.props.label);
  }

  render() {
    return (
      <div>
        <label>
          <input
            type="checkbox"
            value={this.props.label}
            checked={this.state.isChecked}
            onChange={this.toggleCheckboxChange}
        /> {labelNames[this.props.label]}
        </label>
      </div>
    );
  }
}

function Score(props) {
  let fours = props.fours;
  let total = 0;
  for (let i = 1; i <= props.max; i++) {
    if (fours[i]) total++;
  }
  return (
    <div>Score: {round(total / props.max * 100)}%</div>
  );
}

function NumberList(props) {
  let fours = props.fours;
  let listItems = [];
  for (let i = 1; i <= props.max; i++) {
    listItems.push(<div className={fours[i] ? null : "missing"} key={i.toString()}>
      {i} = {fours[i]}
    </div>);    
  }
  return (
    <div>
      <table width="100%">
        <tbody>
          <tr>
            {chunks(listItems, 4).map(
              (chunk, i) => <td key={i} width="25%" valign="top">
                {chunk}
              </td>)}
          </tr>
        </tbody>
      </table>
    </div>
  );
}

function chunks(array, n) {
  const chunkSize = Math.ceil(array.length / n);
  let results = [];
  for (let i = 0; i < n; i++) {
    results.push(array.slice(i * chunkSize, (i + 1) * chunkSize));
  }
  return results;
}

function round(value) {
    return +(Math.round(value + "e+6") + "e-6");
}

function factorial(num) {
  if (num < 0) 
        return -1;
  else if (num == 0) 
      return 1;
  else {
      return (num * factorial(num - 1));
  }
}

ReactDOM.render(
  <FourFours />,
  document.getElementById('root')
);
