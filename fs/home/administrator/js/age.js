/*
 * Calculate the age from 2 arguments:
 *   birthDate: date of birth value
 *   otherDate: date to compare with
 */
function age(birthDate, otherDate) {
    var years = otherDate.year().minus(birthDate.year());
 
    if (otherDate.month().lt(birthDate.month()).value() ||
        otherDate.month().eq(birthDate.month()).value() && otherDate.dayOfMonth().lt(birthDate.dayOfMonth()).value()) {
        years = years.minus(1);
    }
 
    return years;
}